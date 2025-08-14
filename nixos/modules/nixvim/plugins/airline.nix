{ pkgs, ... }:

{
  programs.nixvim.plugins.airline = {
    enable = true;

    settings = {
      powerline_fonts = 1;
      skip_empty_sections = 1;
      theme = "transparent";
    };
  };

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    vim-airline-themes
  ];
}
