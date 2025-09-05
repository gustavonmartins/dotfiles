# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  networking.hostName = "blackview"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

# Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services = {
    xserver={
      enable=true;
      desktopManager = {
        xfce = {
          enable = true;
          noDesktop = false;
          enableXfwm = true ;
        };
      };
      windowManager ={
        awesome.enable = true;
      };

    };
    displayManager.defaultSession = "xfce+awesome";
    # prevents video bugs like tearing or freezing after inacitivit using Intel GPU
    picom = {
      enable = true;
      vSync = true;
    };
    # Bluetooth icon on XFCE 
    blueman.enable = true;
    
    redshift = {
      enable = true;
      temperature = {
	    day = 3500;
	    night = 3000;
      };
    };
    
    # Configure keymap in X11
  xserver = {
    xkb.layout = "de, us";
    xkb.variant = "";
  };
  };
  
  
  
  location = {
      provider = "manual";
      latitude = 52.5;
      longitude = 13.4;
  };


  

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
	  alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.thunar = {
  enable = true;
  plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    ];
  };
  
  programs.kdeconnect.enable = false;
  
  # Enable automatic system upgrades daily
  system.autoUpgrade = {
    enable = true;
    flake = "etc/server/nixos";
    flags = [
        "--update-input" "nixpkgs"
    ];
    allowReboot = false;
  };
  
  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";          # Run garbage collection daily
    options = "--delete-older-than 30d"; # Delete generations older than 30 days
  };

  
  
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  services = {
    syncthing = {
      enable = false;
      user = "syncthing";
      group = "syncthing_grp";
      dataDir = "/mnt/syncthing";
      overrideFolders = false;
      overrideDevices = false;
    };
    jellyfin = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin_grp";
      openFirewall = true;
    };
    sonarr = {
      enable = false;
      user = "sonarr";
      group = "jellyfin_grp";
    };
    radarr = {
      enable = false;
      user = "radarr";
      group = "jellyfin_grp";
    };
    prowlarr = {
      enable = true;
    };

    jellyseerr.enable=false;
    
    
    
    
    
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  users.groups.jellyfin_grp.members = ["radarr" "sonarr" "jellyfin" "gustavo"];
  users.groups.syncthing_grp.members = ["syncthing" "gustavo"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gustavo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "jellyfin" "syncthing" "libvirtd"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
  #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = false;
  
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "gustavo" = import ./home.nix;
    };
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  
  # Banking
  programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [
	  secp256k1
	];
  
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    
    # Compression
    p7zip unzip xarchiver xz zip
    
    # Desktop
    awesome xfce.xfconf xfce.xfce4-fsguard-plugin xfce.gigolo xfce.xfce4-netload-plugin xfce.orage xfce.xfce4-weather-plugin xfce.xfce4-xkb-plugin
    
    # Internet browsers
    brave librewolf lynx tor-browser ungoogled-chromium
    
    # Mail
    isync kdePackages.kmail mutt neomutt thunderbird 
    
    # Media
    ffmpeg mpv smplayer
    
    # Mobile-PC integration
    kdePackages.dolphin sshfs # for kde connect
    
    # Office
    gnumeric libreoffice
    
    # Passwords
    gnupg keepassxc

    # Programming
    git
    
    # System tools
    eza htop lsd
    
    # Search tools
    skim fzf ripgrep ripgrep-all
    
    # Text editors
    geany notepadqq

    # Virtualization
    qemu libvirt-glib
  ];
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = ["gustavo"];

  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
  };
};
  programs.virt-manager.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    firewall = {
      enable = true;
    };
    nftables={
      enable=true;
      flushRuleset = true; 
      ruleset=''
      table inet filter {
        set LAN {
          type ipv4_addr;
          flags interval;
          elements = { 192.168.0.0/24, 192.168.1.0/24 }
        }
      
        chain input {
          type filter hook input priority 0; policy drop;
          
          # Allow loopback
          iif lo accept;
          
          # Allow replies to connections initiated by myself
          ct state established,related accept;

          # Allow from jellyfin
          ip saddr @LAN tcp dport 8096 accept;
          ip saddr @LAN udp dport 7359 accept;
          
          # Allow from syncthing
          ip saddr @LAN tcp dport 22000 accept;
          ip saddr @LAN udp dport {21027,22000} accept;
          
          # Allow from KDE connect
          # allow KDE Connect ports both TCP and UDP 1714-1764
          ip saddr @LAN tcp dport 1714-1764 accept
          ip saddr @LAN udp dport 1714-1764 accept
          
          # Allow ICMP (ping)
          ip protocol icmp icmp type echo-request accept;
          ip protocol icmp icmp type echo-reply accept;
          
          # Allow bittorrent
          tcp dport {65000,6771} log prefix "bittorrent incoming tcp accepted: " accept;
          udp dport {65000,6771} log prefix "bittorrent incoming udp accepted: " accept;
          
          
          # Default drop all other input
          log prefix "Incoming  blocked: " drop;
        }

        chain output {
          type filter hook output priority 0; policy accept;
          
          # Allow loopback
          # oif lo accept;
          
          # Allow replies to connections initiated by myself
          # ct state established,related log prefix "Outgoing  accepted from before: " accept;
          
          # allow DHCP NTP DNS
          # udp dport {68, 123, 53 } log prefix "Outgoing UDP accepted: " accept
          
          # allow HTTP, HTTPS
          # tcp dport {80, 443} log prefix "Outgoing TCP accepted: " accept;
          
          # allow BIT TOrrent
          # tcp dport 6881-6999 log prefix "bittorrent outgoing tcp accepted: " accept;
          
          # All outgoing traffic accepted
          
          # log prefix "Outgoing  blocked: " drop;
        }

        chain forward {
          type filter hook forward priority 0; policy drop;
        }
      }
    '';
    };
    };

  # Fonts
    fonts.packages = with pkgs; [
      terminus_font
      terminus_font_ttf
      termsyn
      tamsyn
      iosevka
      nerd-fonts.jetbrains-mono
    ];
  
  services.fail2ban = {
    enable = true;
    # Use nftables for banning IPs
    banaction = "nftables-multiport";
    
    # Optional: ignore local IP range to not ban internal addresses
    ignoreIP = ["127.0.0.1"];
  };
  
  services.i2pd = {
    enable = false;
    address = "127.0.0.1"; # or "0.0.0.0" if using SSH tunnel
    proto = {
      http.enable = true;
      socksProxy.enable = true;
      httpProxy.enable = true;
    };
  };
  
  systemd.services.fail2ban.serviceConfig = {
    Requires = [ "nftables.service" ];
    After = [ "nftables.service" ];
  };
  
  services.tor = {
    enable = true;
    # Optional settings
    enableGeoIP = false;  # disables GeoIP to avoid country-based statistics
    # Additional configuration can be specified in 'settings'
    settings = {
      ClientUseIPv4 = true;
      ClientUseIPv6 = false;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

