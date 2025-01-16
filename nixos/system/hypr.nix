{ inputs, config, pkgs, ... }:

{
  # Enable Cachix for Hyprland binaries
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Environment variables for Wayland support
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint for Electron apps to use Wayland

  };

  # Install required packages
  environment.systemPackages = with pkgs; [
    # Terminals
    kitty
    foot

    # Icon themes
    dracula-icon-theme
    nordzy-icon-theme
    epapirus-icon-theme
    morewaita-icon-theme
    la-capitaine-icon-theme
    gnome-icon-theme

    # Hyprland utilities
    waybar                 # Status bar
    swaynotificationcenter # Notifications
    hyprpaper              # Wallpaper
    rofi-wayland           # Application launcher
    grim                   # Screenshots
    slurp                  # Screenshot region selector
    hyprshot               # Hyprland-specific screenshots
    cliphist               # Clipboard manager
    wl-clipboard           # Clipboard utilities
    wlogout                # Logout menu

    # GTK and QT Themes
    #magnetic-catppuccin-gtk
    #tokyonight-gtk-theme
    catppuccin-kvantum
                # Setup GTK themes
    #libsForQt5.qt5ct
    #libsForQt5.qtstyleplugin-kvantum
    #kdePackages.qt6ct
    #qt5.qtwayland
    #qt6.qtwayland

    # Utilities
    pavucontrol            # Audio control
    polkit_gnome           # Polkit authentication
    hyprpicker             # Color picker
    wtype                  # Typing automation
    font-manager           # Font management
    xdg-desktop-portal-hyprland # XDG Portal
  ];
}

