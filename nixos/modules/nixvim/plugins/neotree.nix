{
  programs.nixvim.plugins.neo-tree = {
    enable = true;
    settings.close_if_last_window = true;
    settings.filesystem.follow_current_file.enabled = true;
  };
}
