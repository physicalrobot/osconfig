{
  programs.nixvim.plugins = {

    hmts.enable = true;

    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        clangd.enable = true;
        pylsp.enable = true;
        html.enable = true;
      };
    };
  };
}
