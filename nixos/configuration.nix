{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system/hypr.nix  # Hyprland settings in a separate file for modularity
    # Add more modular configurations as needed
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "tars";
  networking.networkmanager.enable = true;

  # Timezone and localization
  time.timeZone = "America/Los_Angeles";
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

  # Fonts
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-mono
      nerd-fonts.jetbrains-mono
    ];
  };

  # Enable X11 windowing system
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    xkb = {
      layout = "us";
      variant = "";
    };
    libinput.enable = true;
  };

  # Printing and Bluetooth
  services.printing.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Sound with PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.viku = {
    isNormalUser = true;
    description = "viku";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Enable automatic login for the user
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "viku";
  };

  services.flatpak.enable = true;


  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};

  # System packages
  environment.systemPackages = with pkgs; [
    dolphin
    hyprland
    waybar
    wl-clipboard
    wlogout
    swaylock
    mako
    alacritty
    libinput
    kitty
    git
    nix
    udisks2
    wofi
    starship
    hyprpaper
    neovim
    emacs
    gcc
    clang
    cmake
    unzip
    ninja
    pipewire
    pavucontrol
    vlc
    vscode
    github-desktop
    keepassxc
    spotify
    obsidian
    tokyonight-gtk-theme
    qbittorrent
    brave
    librewolf
    firefox
    flatpak
    steam

  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  # Miscellaneous settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}

