{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "blackview";
  networking.hostId = "98bb38a3";

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "datapool" ];

  /*
    zfs set atime=off    datapool
    zfs set devices=off  datapool
    zfs set exec=off     datapool
    zfs set setuid=off   datapool
  */

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 0; # disable 15-min snapshots
    hourly = 0;
    daily = 60;
    weekly = 26;
    monthly = 0;
  };

  systemd.services."zfs-snapshot-init" = {
    description = "Enable ZFS auto-snapshot on datasets";
    wantedBy = [ "multi-user.target" ];
    after = [ "zfs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.zfs}/bin/zfs set com.sun:auto-snapshot=true datapool/radicale
      ${pkgs.zfs}/bin/zfs set com.sun:auto-snapshot=true datapool/gustavo
    '';
  };

  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" ];
        ssl = true;
        certificate = "/var/lib/radicale/cert.pem";
        key = "/var/lib/radicale/cert.key";
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "bcrypt";
        # for new password: htpasswd -B /var/lib/radicale/users gustavo
      };
      #storage = {
      #    filesystem_folder = "/var/lib/radicale/collections";
      #    hook = "git add -A && git commit -m 'auto'";
      #  };
      # your existing server/storage options...
    };
  };

}
