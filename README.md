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

Bootstrap installs all packages (Homebrew + bundle on macOS, apt/dnf/pacman on Linux), shell plugins, CLI tools, VS Code extensions, crontab, and macOS system settings (wallpaper, Dock).

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

## Submodules

```sh
yadm submodule update --recursive --init
```

Includes: [tpm](https://github.com/tmux-plugins/tpm) (tmux), [oh-my-zsh](https://ohmyz.sh/).
