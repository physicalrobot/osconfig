{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Modular system configurations
    ./system/hypr.nix        # Hyprland settings
    ./system/audio.nix       # PipeWire and audio settings
    ./system/filesystems.nix # Filesystem mount configurations
    ./system/gaming.nix      # Gaming-related settings
    ./system/nvidia.nix      # NVIDIA-specific settings (only applies if needed)
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

  # Jellyfin Media Server
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Printing and Bluetooth (kept general)
  services.printing.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # User configuration
  users.users.viku = {
    isNormalUser = true;
    description = "viku";
    extraGroups = [ "networkmanager" "wheel" ]; 
  };

  # Enable automatic login for the user
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "viku";
  };

  services.flatpak.enable = true;
  programs.firefox.enable = true;

  # System packages
  environment.systemPackages = import ./system-packages.nix { pkgs = pkgs; };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct"; 
    style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    }; 
  };  

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
