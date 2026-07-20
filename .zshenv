# Locale — OS-conditional, shared with Linux hosts.
# macOS libc has no C.UTF-8 locale (setlocale silently falls back to C, which
# breaks wcwidth agreement between the tmux server and TUI apps → garbled
# redraws), and the terminal emulator may inject an invalid LC_CTYPE=UTF-8,
# so pin en_US.UTF-8 via LC_ALL there.
# Trade-offs:
#   - LC_ALL=en_US.UTF-8 changes collation (sort order) vs the C locale.
#   - macOS ssh forwards LANG/LC_* via SendEnv, so remote hosts must have
#     en_US.UTF-8 generated.
# Never export TERM here — it must be set by the terminal emulator / tmux.
if [[ $OSTYPE == darwin* ]]; then
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8   # overrides emulator-injected LC_CTYPE
else
  export LANG=C.UTF-8
fi
