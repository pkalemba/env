# dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/).

## Fresh install

**macOS** — install yadm before Homebrew:

```sh
curl -fLo /usr/local/bin/yadm \
  https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
  && chmod a+x /usr/local/bin/yadm
```

**Linux:**

```sh
sudo apt install yadm      # Debian/Ubuntu
sudo dnf install yadm      # Fedora
sudo pacman -S yadm        # Arch
```

Then clone and bootstrap:

```sh
yadm clone <repo-url>
yadm bootstrap
```

Bootstrap installs all packages (Homebrew + bundle on macOS, apt/dnf/pacman on Linux), shell plugins, CLI tools, VS Code extensions, crontab, and macOS system settings (wallpaper, Dock, keyboard remapping via `hidutil` — see `.local/bin/hidutil-remap`).

## Daily use

```sh
yadm status
yadm add ~/.some_file
yadm commit -m "feat: ..."
yadm push
```

## Encrypted files

Sensitive files (`.ssh/*`, `.gitconfig`, `.zsh_aliases`, atuin/1Password configs) are stored encrypted.

```sh
yadm encrypt               # after editing
yadm decrypt               # on a new machine
```

## Conditional files

- `file##os.Darwin` — macOS only
- `file##template` — Jinja2 template; use `{% if yadm.os == "Darwin" %}` for OS branching

## tmux / TUI rendering on macOS

Fixes for garbled TUI redraws (vim, Claude Code) inside tmux:

- `.zshenv` sets the locale per OS: `en_US.UTF-8` (via `LC_ALL`) on macOS —
  `C.UTF-8` is not a valid locale in macOS libc and silently falls back to `C`,
  breaking wcwidth — and `C.UTF-8` on Linux. Trade-offs: `LC_ALL=en_US.UTF-8`
  changes collation (sort order), and macOS ssh forwards `LANG LC_*` via
  `SendEnv`, so remote hosts must have `en_US.UTF-8` generated.
- Bootstrap compiles a modern `tmux-256color` terminfo (with `Smulx`/`Ss`/`Se`)
  from Homebrew ncurses into `~/.terminfo`, shadowing the ancient system entry.

Manual steps:

1. Disable "Set locale environment variables automatically" in
   iTerm2 (Profiles → Terminal) or Terminal.app (Settings → Profiles →
   Advanced) — the emulator otherwise injects an invalid `LC_CTYPE=UTF-8`.
2. Run `tmux kill-server` and start a fresh session — the running tmux server
   keeps the locale and terminfo it saw at first start.

Verify in the fresh session:

```sh
locale                                  # every variable en_US.UTF-8, no warnings
echo "zażółć ═╬═ ✔ 🚀"                  # renders correctly
infocmp -x tmux-256color | grep Smulx   # match → new terminfo active
```

vim should show clean box-drawing borders and undercurl; Claude Code should
redraw cleanly.

## Submodules

```sh
yadm submodule update --recursive --init
```

Includes: [tpm](https://github.com/tmux-plugins/tpm) (tmux), [oh-my-zsh](https://ohmyz.sh/).
