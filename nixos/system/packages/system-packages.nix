# system-packages.nix
{ pkgs }: with pkgs; [
  kdePackages.dolphin
  hyprland
  waybar
  wl-clipboard
  wlogout
  swaylock
  mako
  alacritty
  libinput
  kitty
  git
  nix
  udisks2
  wofi
  starship
  hyprpaper
  gcc
  clang
  cmake
  unzip
  ninja
  pipewire
  pavucontrol
  vlc
  vscode
  github-desktop
  keepassxc
  spotify
  obsidian
  qbittorrent
  brave
  librewolf
  kdePackages.qtstyleplugin-kvantum
  libsForQt5.qtstyleplugin-kvantum
  libsForQt5.qt5ct
  flatpak 
  lazygit
  cmatrix
  discord
  graphite-gtk-theme
  nwg-look
  btop
  ripgrep 
  lua-language-server 
  ghostty
  gnome-keyring
  SDL2_ttf
  SDL2_net
  SDL2_gfx
  SDL2_sound
  SDL2_mixer
  SDL2_image
  rclone
  jellyfin
  jellyfin-web
  ntfs3g  
  jellyfin-mpv-shim
  mpvpaper
  pandoc
  graphviz
  vimwiki-markdown
  emacs30-pgtk
  gimp
  inkscape 
  superfile
]

