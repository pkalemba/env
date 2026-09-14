# Repo conventions

This repository **is** `$HOME`, tracked with [yadm](https://yadm.io/). Only
explicitly added files are followed. Paths here are relative to the home
directory, so `.tmux.conf` in this repo is `~/.tmux.conf` on a machine.

## File naming

yadm resolves suffixes at checkout time:

- `file##os.Darwin` — installed on macOS only.
- `file##template` — Jinja2 template. Conditions in use:
  `{% if yadm.os == "Darwin" %}` and `{% if yadm.class == "work" %}`
  (class comes from `yadm config local.class`).

Never edit the rendered file on a machine; edit the template here.

## Ordering contracts

Two places depend on ordering and will break quietly if rearranged. Both carry
comments saying so — read them before touching:

- **`.zshrc##template`**: `zsh-defer` is loaded from `.zsh_plugins_pre.txt`
  first, `compinit` is queued before the main bundle (the defer queue is FIFO
  and `fzf-tab` calls `compdef` at load), and `zsh-syntax-highlighting` is last.
- **`.tmux.conf`**: every `set` on a `*-style` option replaces the whole style
  string. `bg=` and `fg=` must be a single declaration or the first is dropped.

## Things that are deliberately the way they are

- `allow-passthrough off` in `.tmux.conf` — turning it on brings back TUI
  redraw artifacts. It has already been re-enabled by accident once.
- `starship` is not deferred; deferring the prompt flashes the default one.
- `.config/yadm/encrypt` lists `.ssh/*` and `.ssh/1Password/*` separately
  because the glob does not cross `/`. Do not "simplify" without verifying —
  getting it wrong commits private keys in plaintext.
- The AstroNvim files under `lua/plugins/` that start with
  `if true then return {} end` are upstream scaffolding, intentionally inert.

## Single sources of truth

| Concern | Lives in |
|---|---|
| VSCodium settings + extensions | `.config/vscodium/settings/profiles/main/data/` |
| macOS packages | `.Brewfile##template` |
| Linux packages | the `Linux` branch of `.config/yadm/bootstrap` |
| zsh plugins | `.zsh_plugins_pre.txt`, `.zsh_plugins.txt` |

Keep the Brewfile and the bootstrap's Linux package list in step; a package
that is work-class in one should be work-class in the other.

## Before committing

CI (`.github/workflows/lint.yml`) runs these; run what is relevant locally:

```sh
shellcheck -s sh .config/yadm/bootstrap
tmux -L lint -f /dev/null new-session -d && tmux -L lint source-file "$PWD/.tmux.conf"
zsh -n .zshenv .config/zsh/functions.zsh
stylua --check .config/astronvim
python3 -c "import json;json.load(open('.config/vscodium/settings/profiles/main/data/settings.json'))"
```

`.zshrc##template` cannot be checked directly — render it for each
OS/class combination first, then `zsh -n` the result.

Commit messages follow `.gitmessage` (Conventional Commits). The type list
there is mirrored in the `claudeCommitGen.prompt` setting; CI fails if the two
drift apart.
