{ pkgs, ... }:
{
  imports = [
    ./opts.nix
    ./keymaps.nix
    ./autocmds.nix
    ./plugins/all.nix
  ];


  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
    plugins.alpha.enable = true;

extraPlugins = with pkgs.vimPlugins; [
      vimwiki 
    ];
extraConfigVim = ''
      let g:vimwiki_list = [{
        \ 'path': '~/wiki/',
        \ 'syntax': 'markdown',
        \ 'ext': '.md'
      \ }]
      let g:vimwiki_global_ext = 0
    '';
  };
}

