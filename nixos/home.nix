{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "viku";
  home.homeDirectory = "/home/viku";

  # This value determines the Home Manager release that your configuration is compatible with.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Ghostty configuration
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty; # Ensure Ghostty is available in your package set

    settings = {
      background-blur-radius = 20;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      window-theme = "dark";
      background-opacity = 0.8;
      minimum-contrast = 1.1;
      keybind = "global:ctrl+grave_accent=toggle_quick_terminal";
    };

  };

   programs.nixvim = {
    enable = true;
    colorschemes = {
      catppuccin = {
        enable = true;
      };
    };
    plugins = {
      lualine = {
        enable = true;
      };
    };
  };

  # programs.doom-emacs = {
  #  enable = true;
  #  doomPrivateDir = ./modules/doom; # Path to your Doom Emacs configuration
  # };

  textfox = {
    enable = true;
    profile = "neo"; # Replace with the actual Firefox profile name
    config = {
      displayHorizontalTabs = true; # Enable horizontal tabs
    };
  };

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    nerd-fonts.fira-code  ];

  home.file = {
    ".config/kitty".source = ./dots/kitty;
    ".config/hypr".source = ./dots/hypr;
    ".config/backgrounds".source = ./dots/backgrounds;
    ".config/starship.toml".source = ./dots/starship.toml;
    ".config/nvim".source = ./dots/nvim;
    ".config/waybar".source = ./dots/waybar;
    ".bashrc".source = ./dots/bashrc;
    ".config/ghostty".source = ./dots/ghostty;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
