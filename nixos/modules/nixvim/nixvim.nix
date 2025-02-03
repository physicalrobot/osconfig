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

    # Theme and UI
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
    plugins.alpha.enable = true;

    # Plugins
    extraPlugins = with pkgs.vimPlugins; [
      vimwiki
      (pkgs.vimUtils.buildVimPlugin {
        pname = "vimwiki-graphviz";
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = "wolandark";
          repo = "Vimwiki-Graphviz";
          rev = "master";
          sha256 = "AHHqxPKQ1OzOP5FSqJUtZBTXiBSndHPYVo4HonYVG/Y="; # Updated hash
        };
      })
    ];

    # Vimwiki Configuration
    extraConfigVim = ''
  
    let g:vimwiki_list = [
      \ {'path': expand('~/wiki/'), 'syntax': 'markdown', 'ext': '.md'},
      \ {'path': expand('~/file-island/'), 'syntax': 'markdown', 'ext': '.md'},
  \ {'path': expand('~/Documents/gdrive/MyVault/Chitragupta/'), 'syntax': 'markdown', 'ext': '.md', 
     \ 'index': '6 - Main Notes'}
      \ ]

      let g:vimwiki_global_ext = 0
      let g:vimwiki_customwiki2html='/intax/roze/.vim/plugged/vimwiki/autoload/vimwiki/customwiki2html.sh'

      " Graphviz settings
      let g:vimwiki_markdown_link_ext = 1
      let g:vimwiki_ext2syntax = {'.md': 'markdown'}
      let g:vimwiki_export = 1
      let g:vimwiki_use_custom_wiki2html = 1 
      let g:vimwiki_custom_wiki2html = '~/file-island/VimWiki-Graphviz.py -m'
      let g:vimwiki_graphviz_executable = 'dot'
      let g:vimwiki_graphviz_output_format = 'png' " Output format
  
      '';
  };
}

