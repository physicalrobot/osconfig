{ config, pkgs, ... }:

let
  homeDirectory = "/home/viku";
in
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "viku";
    homeDirectory = homeDirectory;
    stateVersion = "24.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your environment.
    packages = [];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
    file = {
      ".config/hypr".source = ./dots/hypr;
      ".config/backgrounds".source = ./dots/backgrounds;
      ".config/starship.toml".source = ./dots/starship.toml;
      ".config/waybar".source = ./dots/waybar;
      ".bashrc".source = pkgs.writeText "bashrc" (builtins.readFile ./dots/bashrc);
      ".config/ghostty".source = ./dots/ghostty;
      ".config/doom/".source = ./dots/doom; 
    };


    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Ghostty configuration
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty; # Ensure Ghostty is available in your package set
    settings = {
      background-blur-radius = 20;
      enable-clipboard = false;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      window-theme = "dark";
      background-opacity = 0.8;
      minimum-contrast = 1.1;
      keybind = "global:ctrl+grave_accent=toggle_quick_terminal";
    };
  };

  imports = [
    ./modules/nixvim/nixvim.nix
  ];

  programs.nixvim = {
    enable = true;
    plugins.lualine.enable = true;
  };

  # Enable Textfox with its module
  textfox = {
    enable = true;
    profile = "neo"; # Replace with the actual Firefox profile name
    config.displayHorizontalTabs = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
