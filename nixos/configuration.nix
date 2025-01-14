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
  
  networking.hostName = "tars"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
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

  fonts = {

      fontDir.enable = true;

      fontconfig.enable = true;

   };

 
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver ={

     enable = true;
     videoDrivers = ["nvidia"];
     displayManager.gdm = {
          enable = true;
          wayland = true;
     };
   };

  hardware = {
     graphics.enable = true;
     nvidia.modesetting.enable = true;
     nvidia.open = true;
  };

  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
  };



  # Enable the KDE Plasma Desktop Environment.
   services.displayManager.sddm.enable = false;

   services.desktopManager.plasma6.enable = false;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.udisks2.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.viku = {
    isNormalUser = true;
    description = "viku";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "viku";

  # Install firefox.
  programs.firefox.enable = true;

  # Starship
  programs.starship.enable = true;
 
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
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
  starship
  hyprlock
  hyprcursor
  libsForQt5.qtstyleplugin-kvantum
  libsForQt5.qt5ct
  #(pkgs.nerdfonts.override {
   # fonts = [ "CaskaydiaMono" "FiraCode" "JetBrainsMono" ];
  #})

  gcc
  clang
  cmake
  unzip
  ninja
  pipewire
  pavucontrol

  #inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

fonts.packages = with pkgs; [
  nerd-fonts.fira-code
  nerd-fonts.caskaydia-mono
  nerd-fonts.jetbrains-mono
];

  environment.sessionVariables = {
  QT_QPA_PLATFORM = "wayland";
  QT_QPA_PLATFORMTHEME = "qt5ct";

  };

  services.xserver.libinput.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];



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
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
