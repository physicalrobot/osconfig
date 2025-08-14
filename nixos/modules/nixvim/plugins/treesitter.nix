{ pkgs, ... }:

{
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      highlight = {
        enable = true;
      };
      settings = {
        indent = {
          enable = true;
        };
      };
    };

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      c
      json
      lua
      make
      markdown
      nix
      python
      regex
      toml
      vim
      vimdoc
      xml
      yaml
    ];
  };
}
