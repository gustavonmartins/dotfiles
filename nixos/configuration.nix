# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  networking.hostName = "blackhawk"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # nix.settings.experimental-features = ["nix-command" "flakes"];

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
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver = {
      displayManager.lightdm.enable = true;
    };
  
  services.displayManager.defaultSession = "xfce+awesome";

  services.xserver.desktopManager = {
    xfce = {
      enable = true;
      noDesktop = true;
      enableXfwm = false;
    };
    cde.enable = true;
  };

  services.xserver.windowManager = {
    awesome.enable = true;
    openbox.enable = true;
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  location = {
    provider = "manual";
    latitude = 52.5;
    longitude = 13.4;
  };

  services.redshift = {
    enable = true;
    temperature = {
	    day = 5500;
	    night = 3700;
    };
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de, us";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services = {
    syncthing = {
      enable = true;
      user = "gustavo";
      dataDir = "/home/gustavo/Documents/Syncthing/";
      overrideFolders = false;
      overrideDevices = false;
    };
    jellyfin = {
      enable = true;
      user = "gustavo";
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      user = "gustavo";
      openFirewall = true;
    };
    radarr = {
      enable = true;
      user = "gustavo";
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    readarr = {
      enable = true;
      openFirewall = true;
      user = "gustavo";
    };
    lidarr = {
      enable = true;
      user = "gustavo";
      openFirewall = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gustavo = {
    isNormalUser = true;
    description = "Gustavo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  neovim vscodium git notepadqq
  skim fzf ripgrep ripgrep-all zsh alacritty
  google-drive-ocamlfuse
  thunderbird claws-mail gnome.geary
  stow
  librewolf lynx ungoogled-chromium
  gajim element-desktop hexchat signal-desktop telegram-desktop zulip jitsi
  rofi polybar tint2 lemonbar motif
  keepassxc
  libreoffice calibre
  evince mupdf okular zathura ocrmypdf
  treesheets freemind freeplane xmind vym vue # Compendium
  htop
  qbittorrent
  # media
  pavucontrol
  mpv smplayer hypnotix vlc yt-dlp
  ffmpeg
  handbrake
  mediainfo mediainfo-gui
  shortwave goodvibes tuner # gnomeradio
  #
  gnupg
  # Virtualization
  qemu libvirt-glib
  pinta krita digikam
  #
  lshw
  openspades teeworlds
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
      allowedTCPPorts = [8096];
    };
    nftables.enable = true;
  };


  # Fonts
  fonts.packages = with pkgs; [
    terminus_font
    terminus_font_ttf
    termsyn
    tamsyn
    iosevka
    (nerdfonts.override {fonts =["JetBrainsMono"];})
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
