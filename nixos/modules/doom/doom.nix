{ pkgs, lib, config, ... }:

{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = "${config.home.homeDirectory}/.config/doom"; # Uses correct home path
  };

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    (nerdfonts.override { fonts = [ "FiraCode" ]; }) # Doom Icons
  ];

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      git clone --depth 1 https://github.com/doomemacs/doomemacs.git "$HOME/.config/emacs"
      $HOME/.config/emacs/bin/doom install
    fi
  '';
}

