{
  programs.nixvim.plugins.floaterm = {
    enable = true;

    width = 0.8;
    height = 0.8;
    shell = "/run/current-system/sw/bin/bash";

    title = "";

    keymaps.toggle = "<C-b>";
  };
}
