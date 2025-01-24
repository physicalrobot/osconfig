{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "viku";
  home.homeDirectory = "/home/viku";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Ghostty configuration
  ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${system}.default;
    shellIntegration.enable = true;

    settings = {
      background-blur-radius = 20;
      theme = "dark:catppuccin-mocha,light:catppuccin-latte";
      window-theme = "dark";
      #window-theme = "system"; # TODO make vim and terminal somehow respect this?
      background-opacity = 0.8;
      minimum-contrast = 1.1;
    };

    keybindings = {
      # keybind = global:ctrl+`=toggle_quick_terminal
      "global:ctrl+`" = "toggle_quick_terminal";
    };
  };

   programs.nixvim = {
    enable = true;

    colorschemes = {
      catppuccin-mocha = {
        enable = true;
      };
    };

    plugins = {
      lualine = {
        enable = true;
      };
    };
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d; # Path to your Doom Emacs configuration
  };

  # Enable Textfox with its module
  options.textfox = {
    enable = true;
    profile = "neo"; # Replace with the actual Firefox profile name
    config = {
       # Enable horizontal tabs
      displayHorizontalTabs = true;
      # Optional configurations can be added here
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

  
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hellolib, 

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

      ".config/kitty".source = ./dots/kitty;
      ".config/hypr".source = ./dots/hypr;
      ".config/backgrounds".source = ./dots/backgrounds;
      ".config/starship.toml".source = ./dots/starship.toml;
      ".config/nvim".source = ./dots/nvim; 
      ".config/waybar".source = ./dots/waybar;
      ".bashrc" = ./dots/bashrc;
      ".config/ghostty".source = ./dots/ghostty;
      

   # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/viku/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
