 # My Nix Config File that is cool


{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  #Network Fun Stuff
  networking.hostName = "nixos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "127.0.0.1"];

  # Timezone for me
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.fprintd.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS and IPP
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #pinyin
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  #Chinese Fonts
  fonts.fonts = with pkgs; [
    source-han-serif
  ];

  #My User
  users.users.tux = {
    isNormalUser = true;
    description = "tux";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true; #Supposedly Temporary Fix, as previous line doesn't work:(

  #My Packages!!
  environment.systemPackages = with pkgs; [
    pkgs.alsa-firmware
    pkgs.ardour
    pkgs.sof-firmware
    pkgs.android-studio
    pkgs.android-tools
    pkgs.appimage-run
    pkgs.cargo
    pkgs.cowsay
    pkgs.gnomeExtensions.custom-accent-colors
    pkgs.discord
    pkgs.distrobox
    pkgs.dnscrypt-proxy2
    pkgs.firefox
    pkgs.fprintd
    pkgs.gcc
    pkgs.gimp
    pkgs.git
    pkgs.gnomeExtensions.alphabetical-app-grid
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.burn-my-windows
    pkgs.gnomeExtensions.clipboard-indicator
    pkgs.gnomeExtensions.desktop-cube
    pkgs.gnomeExtensions.gsconnect
    pkgs.gnomeExtensions.hibernate-status-button
    pkgs.gnomeExtensions.media-controls
    pkgs.gnomeExtensions.vitals
    pkgs.gnome.gnome-tweaks
    pkgs.gnumake
    pkgs.google-chrome
    pkgs.inkscape
    pkgs.libsForQt5.kdenlive
    pkgs.libreoffice
    pkgs.microcodeIntel
    pkgs.neofetch
    pkgs.neovim
    pkgs.nvme-cli
    pkgs.jdk
    pkgs.p7zip
    pkgs.protonvpn-gui
    pkgs.python311
    pkgs.deluge
    pkgs.python311Packages.pip
    pkgs.sl
    pkgs.sniffnet
    pkgs.steghide
    pkgs.stegseek
    pkgs.stubby
    pkgs.tor-browser-bundle-bin
    pkgs.vlc
    pkgs.wget
    pkgs.python311Packages.scapy
    pkgs.python311Packages.python-nmap
    pkgs.python311Packages.netifaces
    pkgs.python311Packages.pyx


  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #My Services!
  services.flatpak.enable = true;
  services.fwupd.enable = true;

  #DNS
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	refresh_delay = 72;
      };

       server_names = [ "cloudflare" ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  #wireguard
  networking.firewall.checkReversePath = false; 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [...];
    networking.firewall.allowedUDPPorts = [51820];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  #Open ports in a specific range
  networking.firewall = { 
      enable = true;
      allowedTCPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
      allowedUDPPortRanges = [ 
        { from = 1714; to = 1764; } # KDE Connect
      ];  
    };  


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Automatic Garbage Collection
  nix.gc = {
                  automatic = true;
                  dates = "monthly";
                  options = "--delete-older-than 30d";
          };
  # Auto system update
  system.autoUpgrade = {
        enable = true;
  };

}
