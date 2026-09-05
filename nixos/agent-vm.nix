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

  networking.firewall.enable = true;

  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.100.2";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = {
    address = "192.168.100.1";
    interface = "eth0";
  };
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      FallbackDNS = [ ];
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    #glibc
    #libffi
    #openssl
    secp256k1
    stdenv.cc.cc.lib
    #zlib
  ];

  environment.systemPackages = with pkgs; [
    #opencode
    # pi-coding-agent

    # Programming
    bun
    deno

    zed
  ];

  users.users.agent = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkHt/Ui3Ih2SC3ZalfDguhFcCHLIFvVGf3/rlSsDw6Y martins.yo@gmail.com"
    ];
  };

  microvm = {
    hypervisor = "qemu";
    qemu.serialConsole = true;
    vsock.cid = 42;
    vsock.ssh.enable = true;

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
        type = "tap";
        id = "agent-vm";
        mac = "02:00:00:00:00:01";
      }
    ];
    vcpu = 4;
    mem = 4096;
  };

}
