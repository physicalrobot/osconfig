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
    #colorschemes.nightfox.enable = true;
     
    # colorschemes.dracula-nvim.enable = true;
    # colorschemes.nightfox.flavor = "duskfox";
    # colorschemes.poimandres.enable = true;
  };
}

