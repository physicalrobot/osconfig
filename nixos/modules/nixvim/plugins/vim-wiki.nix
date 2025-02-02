{ pkgs, ... }: {
  programs.nixvim.plugins.vimwiki = {
    enable = true;
    settings = {
      vimwiki_list = [
        {
          path = "~/wiki";
          syntax = "markdown";
          ext = ".md";
          auto_diary_index = 1;
        }
      ];
      vimwiki_global_ext = 0;
    };
  };
}

