# cerebro.md — NixOS Config Reference

> Single-file mental model of the NixOS / Home Manager setup.
> Repo: `~/.dotfiles/nixos/` | Last updated: 2026-02-27

---

## 1. Overview

| Item | Value |
|------|-------|
| Repo root | `~/.dotfiles/nixos/` |
| Flake entry | `flake.nix` |
| nixpkgs channel | `nixos-unstable` (+ `nixos-24.11` stable pinned) |
| Hosts | `tars` (x86_64-linux desktop), `digivice` (aarch64-linux MNT Pocket Reform) |
| Home Manager | Embedded in NixOS modules via `home-manager.nixosModules.home-manager` |
| User | `viku` |

**Flake inputs**

| Input | Purpose |
|-------|---------|
| `nixpkgs` | nixos-unstable |
| `nixpkgs-stable` | nixos-24.11 |
| `home-manager` | rycee/home-manager |
| `nixvim` | nix-community/nixvim |
| `catppuccin` | catppuccin/nix |
| `textfox` | adriankarlen/textfox (Firefox CSS) |
| `nur` | nix-community/NUR overlay |

The flake also exposes `devShells.default` (all systems) pulling from `system/packages/dev-packages.nix`.

---

## 2. Annotated File Tree

```
~/.dotfiles/nixos/
├── flake.nix                         # Entry point; defines tars + digivice + devShells
├── home.nix                          # Home Manager: packages, dotfile symlinks, activation
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix         # tars system config
│   │   └── hardware-configuration.nix
│   └── pocket-reform/
│       ├── configuration.nix         # digivice system config
│       └── hardware-configuration.nix
├── modules/
│   └── nixvim/
│       ├── nixvim.nix                # Top-level nixvim import + vimwiki
│       ├── opts.nix                  # vim options (numbers, indent, scroll…)
│       ├── keymaps.nix               # All keybindings; leader = <Space>
│       ├── autocmds.nix              # Autocommands
│       └── plugins/
│           └── all.nix               # Imports all plugin files
│               ├── airline.nix
│               ├── alpha.nix
│               ├── cmp.nix
│               ├── comment.nix
│               ├── floaterm.nix
│               ├── harpoon.nix
│               ├── image.nix
│               ├── lsp.nix
│               ├── mini.nix
│               ├── neotree.nix
│               ├── nixplugin.nix
│               ├── notify.nix
│               ├── telescope.nix
│               ├── tmux-navigator.nix
│               ├── todo-comments.nix
│               ├── transparent.nix
│               └── treesitter.nix
├── system/
│   ├── audio.nix                     # PipeWire (ALSA + pulse compat)
│   ├── filesystems.nix               # Mount configs (tars only)
│   ├── gaming.nix                    # Steam (tars only)
│   ├── hypr.nix                      # Hyprland enable + Wayland env + packages
│   ├── nvidia.nix                    # NVIDIA driver + modesetting (tars only)
│   └── packages/
│       ├── system-packages.nix       # System-wide packages for tars
│       └── dev-packages.nix          # devShell packages
└── dots/                             # Raw dotfiles (symlinked by home.nix)
    ├── bashrc
    ├── starship.toml
    ├── ghostty/
    ├── waybar/
    │   ├── config.jsonc
    │   ├── style.css
    │   └── mocha.css                 # Catppuccin Mocha waybar theme
    ├── hypr/
    │   ├── hypr.conf
    │   ├── hyprlock.conf
    │   └── mocha.conf
    ├── doom/                         # Doom Emacs config (DOOMDIR)
    ├── superfile/                    # Superfile TUI file manager config
    └── backgrounds/                  # Wallpapers
```

---

## 3. Hosts

### tars — x86_64-linux desktop

| Setting | Value |
|---------|-------|
| Bootloader | systemd-boot (EFI) |
| GPU | NVIDIA — open driver, modesetting enabled |
| Display | GDM + Wayland (`wayland = true`) |
| Auto-login | `viku` |
| Timezone | America/Los_Angeles |
| Fonts | FiraCode, CaskaydiaMono, JetBrainsMono (all Nerd) |

**Services enabled on tars**

| Service | Note |
|---------|------|
| Hyprland | via `system/hypr.nix` |
| PipeWire | ALSA + 32-bit + pulse compat |
| Jellyfin | media server, firewall open |
| Steam | remote play + dedicated server firewall open |
| Bluetooth | blueman, power-on-boot |
| Printing | CUPS |
| Flatpak | enabled |
| NetworkManager | default networking |

### digivice — aarch64-linux (MNT Pocket Reform, RK3588)

Shares `home.nix` and `hypr.nix`/`audio.nix` with tars.
**Omits**: `gaming.nix`, `nvidia.nix`, `filesystems.nix`.
**Adds**:
- `linuxPackages_latest` kernel
- `hardware.opengl.enable = true`
- `powerManagement.enable = true`

---

## 4. Home Manager (`home.nix`)

`stateVersion = "24.11"` | `useGlobalPkgs = true` | `useUserPackages = true`
Conflicting files are auto-renamed with `.backup` extension.

**Packages installed via Home Manager**

| Package | Purpose |
|---------|---------|
| `claude-code` | AI coding assistant CLI |
| `ripgrep` | Fast grep |
| `nodejs_20` | JS runtime |

**Symlinked dotfiles**

| HM path | Source |
|---------|--------|
| `~/.config/hypr` | `dots/hypr/` |
| `~/.config/backgrounds` | `dots/backgrounds/` |
| `~/.config/starship.toml` | `dots/starship.toml` |
| `~/.config/waybar` | `dots/waybar/` |
| `~/.bashrc` | `dots/bashrc` (via `pkgs.writeText`) |
| `~/.config/ghostty` | `dots/ghostty/` |
| `~/.config/doom` | `dots/doom/` |
| `~/.config/superfile` | `dots/superfile/` |

**Session variables**

| Variable | Value |
|----------|-------|
| `EDITOR` | `nvim` |

**Activation hook: `doomSync`**
Runs after `writeBoundary`. Compares `~/.config/doom` symlink target against stamp at `~/.local/share/doom/.hm-stamp`. If changed, runs `doom sync -e` and updates the stamp. Failure is non-fatal (retries on next rebuild).

---

## 5. NeoVim / NixVim

**Key options**

| Option | Value | Note |
|--------|-------|------|
| `mapleader` | `<Space>` | also maplocalleader |
| `colorscheme` | catppuccin | |
| `relativenumber` | true | + absolute on current line |
| `scrolloff` | 8 | |
| `tabstop/shiftwidth` | 4 | expandtab, smartindent |
| `swapfile/backup/undofile` | false | no temp files |
| `spell` | true | |
| `ignorecase` + `smartcase` | true | |
| `mouse` | `a` | all modes |
| `shell` | `/run/current-system/sw/bin/bash` | |
| `defaultEditor` | true | sets `$EDITOR` at system level |

**Key mappings (normal mode)**

| Key | Action |
|-----|--------|
| `<leader>s` | Substitute word under cursor (global) |
| `<leader>x` | `chmod +x` current file |
| `<leader>q` | Open Alpha dashboard |
| `<leader>l` | Open Mason |
| `<leader>r` | Reload buffer |
| `<leader>b` | Toggle alternate buffer |
| `<leader>a` | Harpoon: add file |
| `<leader>m` | Harpoon: menu |
| `<leader>1–9` | Harpoon: nav to file 1–9 |
| `<C-e>` | Neotree toggle |
| `<C-s>` | Save |
| `<C-x>` | Close window |
| `<C-c>` | Switch to previous buffer |
| `<leader>h/j/k/l` | Window navigation |
| `<A-i>` | ObsidianTemplate |
| `<leader>op` | ObsidianPasteImg |
| `n / N` | Search next/prev + center |
| `<C-d> / <C-u>` | Half-page scroll + center |
| `<esc>` | Clear search highlight |
| `<M-j> / <M-k>` | Move line down/up |

**Plugins**

| Plugin | Purpose |
|--------|---------|
| lualine | Statusline |
| alpha | Dashboard |
| catppuccin | Colorscheme |
| neotree | File explorer |
| telescope | Fuzzy finder |
| harpoon | File bookmarks |
| cmp | Completion |
| lsp | Language servers (Mason) |
| treesitter | Syntax/parsing |
| todo-comments | Highlight TODOs |
| comment | Easy commenting |
| mini | Mini utilities |
| floaterm | Floating terminal |
| image | Image preview |
| tmux-navigator | Tmux pane nav |
| transparent | Transparent bg |
| notify | Notifications |
| nixplugin | Nix filetype support |
| vimwiki | Wiki / notes |
| vimwiki-graphviz | Graphviz in vimwiki |

**Vimwiki wikis**

| Index | Path | Format |
|-------|------|--------|
| 1 | `~/wiki/` | markdown |
| 2 | `~/file-island/` | markdown |
| 3 | `~/Documents/gdrive/MyVault/Chitragupta/` | markdown (index: `6 - Main Notes`) |

---

## 6. Doom Emacs

| Item | Value |
|------|-------|
| Config dir (`DOOMDIR`) | `~/.config/doom` → symlink to `dots/doom/` |
| Emacs binary | `emacs30-pgtk` (system package) |
| Doom binary | `~/.config/emacs/bin/doom` |
| Sync stamp | `~/.local/share/doom/.hm-stamp` |
| Auto-sync | HM activation runs `doom sync -e` when config changes |
| Quick launch | `mtdoom` alias → `nohup doom run &>/dev/null & disown` |

---

## 7. Shell & Prompt

**Shell**: bash with starship prompt
**Prompt palette**: `catppuccin_mocha` (custom remapped colors)
**Prompt segments** (left→right): os → username → directory → git branch/status → language versions → docker → time

**Environment variables (bashrc)**

| Variable | Value |
|----------|-------|
| `QT_QPA_PLATFORMTHEME` | `qt5ct` |
| `QT_QPA_PLATFORM` | `wayland` |
| `DOOMDIR` | `~/.dotfiles/nixos/dots/doom` |
| `GEM_HOME` / `GEM_PATH` | `~/.gem` |
| `PATH` additions | `~/.config/emacs/bin`, `~/.local/share/nvim/mason/bin`, `~/.gem/bin`, `~/.npm-global/bin` |

**Aliases**

| Alias | Command |
|-------|---------|
| `nixos-rebuild-tars` | `sudo nixos-rebuild switch --flake ~/.dotfiles/nixos/ #tars` |
| `devshell` | `nix develop ~/.dotfiles/nixos#` |
| `mtdoom` | `nohup doom run &>/dev/null & disown` |
| `mount_gdrive` | `rclone mount --daemon gdrive:Obsidian ~/Documents/gdrive` |
| `unmount_gdrive` | `fusermount -uz ~/Documents/gdrive` |
| `vaults` | `cd ~/Documents/gdrive/MyVault` |
| `sites` | `cd ~/Documents/sites` |

---

## 8. Terminal — Ghostty

Managed by `programs.ghostty` in `home.nix`.

| Setting | Value |
|---------|-------|
| Theme | `dark:catppuccin-mocha, light:catppuccin-latte` |
| Window theme | `dark` |
| Background opacity | `0.8` |
| Background blur | `20` |
| Minimum contrast | `1.1` |
| Clipboard integration | disabled |

**Key bindings**

| Key | Action |
|-----|--------|
| `Ctrl+\`` (grave) | Toggle quick terminal (global) |

Other terminals available system-wide: `kitty`, `foot`, `alacritty`.

---

## 9. Wayland / Hyprland

| Setting | Value |
|---------|-------|
| Compositor | Hyprland (via `programs.hyprland.enable = true`) |
| XWayland | enabled |
| Cachix | `hyprland.cachix.org` (binary cache) |
| Env hint | `NIXOS_OZONE_WL=1` (Electron apps use Wayland) |

**Waybar layout**

| Position | Modules |
|----------|---------|
| Left | custom/launcher, hyprland/workspaces, mpris, bluetooth, gamemode, privacy |
| Center | clock (live, with calendar tooltip) |
| Right | tray, cpu, memory, battery, pipewire, backlight, hyprland/language, network, custom/updates |

**Hyprland utilities (system packages)**

| Package | Role |
|---------|------|
| waybar | Status bar |
| swaynotificationcenter | Notifications |
| hyprpaper | Wallpaper |
| rofi | App launcher |
| grim + slurp + hyprshot | Screenshots |
| cliphist + wl-clipboard | Clipboard |
| wlogout | Logout menu |
| hyprpicker | Color picker |
| xdg-desktop-portal-hyprland | XDG portal |
| pavucontrol | Audio GUI |
| polkit_gnome | Auth agent |

---

## 10. Theming

**Color scheme: Catppuccin Mocha** applied at multiple layers:

| Layer | Method |
|-------|--------|
| NixOS system | `catppuccin.nixosModules.catppuccin` |
| NeoVim | `colorschemes.catppuccin.enable = true` |
| Waybar | `dots/waybar/mocha.css` |
| Starship | `palette = 'catppuccin_mocha'` in `starship.toml` |
| Ghostty | `theme = "dark:catppuccin-mocha,light:catppuccin-latte"` |

**Firefox — Textfox**

| Setting | Value |
|---------|-------|
| Module | `textfox.homeManagerModules.default` |
| Profile | `neo` |
| Horizontal tabs | enabled (`displayHorizontalTabs = true`) |

**Qt theming**

| Setting | Value |
|---------|-------|
| Platform theme | `qt5ct` |
| Style package | `utterly-nord-plasma` / `catppuccin-kvantum` |
| GTK theme | `tokyonight-gtk-theme` |
| Icons | dracula, nordzy, morewaita |

---

## 11. Quick Reference: Rebuild & Dev Shells

```bash
# Apply config changes to tars
nixos-rebuild-tars
# expands to: sudo nixos-rebuild switch --flake ~/.dotfiles/nixos/ #tars

# Enter dev shell (pulls dev-packages.nix)
devshell
# expands to: nix develop ~/.dotfiles/nixos#

# Check flake inputs
nix flake metadata ~/.dotfiles/nixos/

# Update all flake inputs
nix flake update ~/.dotfiles/nixos/

# Update single input
nix flake lock --update-input nixpkgs ~/.dotfiles/nixos/

# Run doom manually
mtdoom   # nohup doom run in background

# Mount Google Drive (Obsidian vaults)
mount_gdrive
vaults   # cd to MyVault
```

**Flake experimental features required** (already set in both hosts):
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
