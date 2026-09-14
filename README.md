# dotfiles

Personal dotfiles managed with [yadm](https://yadm.io/).

## Fresh install

**macOS** — install yadm before Homebrew:

```sh
curl -fLo /opt/homebrew/bin/yadm \
  https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
  && chmod a+x /opt/homebrew/bin/yadm
```

On Intel Macs use `/usr/local/bin` instead. Once Homebrew is present,
`brew install yadm` is simpler.

**Linux:**

```sh
sudo apt install yadm      # Debian/Ubuntu
sudo dnf install yadm      # Fedora
sudo pacman -S yadm        # Arch
```

Then clone, **set the host class**, and bootstrap:

```sh
yadm clone <repo-url>
yadm config local.class work     # or: home
yadm bootstrap
yadm decrypt
```

### Host class

`local.class` selects the machine-specific package set in
`.Brewfile##template` and in the Linux branch of the bootstrap. Set it
**before** bootstrapping; if it is unset both conditional blocks are skipped
and you get the shared packages only.

| Class  | Adds |
|--------|------|
| `work` | argocd, postgresql, vault, DBeaver, MeetingBar |
| `home` | Bitwarden, LuLu, WinBox, ZeroTier |

Bootstrap installs packages (Homebrew bundle on macOS, apt/dnf/pacman plus
direct downloads on Linux), shell plugins, the Nerd Font, editor extensions,
sets zsh as the login shell, and applies macOS settings (wallpaper, Dock,
keyboard remapping via `hidutil` — see `.local/bin/hidutil-remap`). It is
idempotent and safe to re-run.

## Daily use

```sh
yadm status
yadm add ~/.some_file
yadm commit -m "feat: ..."
yadm push
```

## Encrypted files

Sensitive files (`.ssh/*`, `.gitconfig`, `.zsh_aliases`, atuin/1Password
configs) are stored encrypted. Note that `.zshrc` sources `~/.zsh_aliases`
only if it exists, so shells work before the first decrypt.

```sh
yadm encrypt               # after editing
yadm decrypt               # on a new machine
```

## Conditional files

- `file##os.Darwin` — macOS only
- `file##template` — Jinja2 template; `{% if yadm.os == "Darwin" %}` for OS
  branching, `{% if yadm.class == "work" %}` for host class

## Shell startup

`.zshrc` loads plugins through [antidote](https://antidote.sh/) and defers the
slow parts with [zsh-defer](https://github.com/romkatv/zsh-defer). The order is
a contract, not a style choice:

1. `zsh-defer` is loaded eagerly from its own list, `.zsh_plugins_pre.txt`.
2. `compinit` is queued **first**, because the defer queue is FIFO and
   `fzf-tab` calls `compdef` when it loads.
3. `.zsh_plugins.txt` then queues `fzf-tab` and, last,
   `zsh-syntax-highlighting`, which wraps widgets defined before it.

`compinit` reuses its dump only when the dump exists and is under a day old;
`-C` skips the fpath security audit, so a missing dump forces a full rebuild.
`starship` is deliberately **not** deferred — deferring the prompt shows a
flash of the default one at every start.

Set `NO_TMUX=1` to stop a shell from auto-attaching to tmux; the VSCodium
integrated terminal does this.

## Editor

Neovim uses `.config/astronvim`, reached via `NVIM_APPNAME=astronvim` exported
from `.zshenv`. Without that variable nvim would look in `~/.config/nvim` and
start unconfigured.

VSCodium settings and the extension list live in
`.config/vscodium/settings/profiles/main/data/` — that profile is the single
source of truth, and bootstrap installs from its `extensions.yml`.

## tmux

New sessions can open a dedicated "proxy" pane. The command is **not** stored
in this repo: create `~/.config/tmux/proxy-command` containing a single line,
and it is typed (not executed) into a second pane on session creation. With no
such file there is no hook and no extra pane.

## tmux / TUI rendering on macOS

Fixes for garbled TUI redraws (vim, Claude Code) inside tmux:

- `.zshenv` sets the locale per OS: `en_US.UTF-8` (via `LC_ALL`) on macOS —
  `C.UTF-8` is not a valid locale in macOS libc and silently falls back to `C`,
  breaking wcwidth — and `C.UTF-8` on Linux. Trade-offs: `LC_ALL=en_US.UTF-8`
  changes collation (sort order), and macOS ssh forwards `LANG LC_*` via
  `SendEnv`, so remote hosts must have `en_US.UTF-8` generated.
- Bootstrap compiles a modern `tmux-256color` terminfo (with `Smulx`/`Ss`/`Se`)
  from Homebrew ncurses into `~/.terminfo`, shadowing the ancient system entry.
- `allow-passthrough` is off on purpose; turning it on reintroduces the redraw
  artifacts. See the comment in `.tmux.conf` before changing it.

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

Includes: [tpm](https://github.com/tmux-plugins/tpm) (tmux).
