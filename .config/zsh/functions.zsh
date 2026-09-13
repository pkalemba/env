# Shell functions, sourced from ~/.zshrc.

# cd, then list the destination.
d() { builtin cd "$@" && ls -F; }

# Extract any common archive format.
extract() {
  if [[ ! -f $1 ]]; then
    print -u2 "extract: '$1' is not a valid file"
    return 1
  fi
  # Compound suffixes must precede their bare forms (*.tar.gz before *.gz).
  case $1 in
    *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
    *.tar.gz|*.tgz)   tar xvzf "$1" ;;
    *.tar.xz|*.txz)   tar xvJf "$1" ;;
    *.tar.zst)        tar --zstd -xvf "$1" ;;
    *.tar)            tar xvf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.xz)             unxz "$1" ;;
    *.zst)            unzstd "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.zip)            unzip "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.7z)             7z x "$1" ;;
    *) print -u2 "extract: don't know how to extract '$1'"; return 1 ;;
  esac
}

# Append a local public key to a remote host's authorized_keys.
#   authme host [pubkey]
authme() {
  local host=$1 key=$2
  if [[ -z $host ]]; then
    print -u2 "usage: authme <host> [public-key]"
    return 1
  fi
  if [[ -z $key ]]; then
    for key in ~/.ssh/id_ed25519.pub ~/.ssh/id_rsa.pub; do
      [[ -r $key ]] && break
    done
  fi
  if [[ ! -r $key ]]; then
    print -u2 "authme: no readable public key (tried id_ed25519.pub, id_rsa.pub)"
    return 1
  fi
  ssh "$host" 'umask 077; mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' < "$key"
}
