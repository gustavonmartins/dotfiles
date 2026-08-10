{
  system,
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.hostPlatform = system;
  networking.hostName = "agent-vm";

  environment.systemPackages = with pkgs; [
    opencode

    # Programming

    deno
  ];

  users.users.agent = {
    isNormalUser = true;
    initialPassword = "test";
  };

  microvm = {
    hypervisor = "qemu";
    qemu.serialConsole = true;

    volumes = [
      {
        image = "nix.img";
        mountPoint = "/";
        size = 20480;
      }
    ];
    #user = "aicoding";
    interfaces = [
      {
        type = "user";
        id = "agent-vm";
        mac = "02:00:00:00:00:01";
      }
    ];
    vcpu = 4;
    mem = 4096;
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2222;
        guest.port = 22;

      }
      # Opencode web
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 4096;
        guest.port = 4096;
      }
    ];
  };

  services.openssh = {
    settings = {
      PermitRootLogin = "no";
    };
    enable = true;
  };

}
