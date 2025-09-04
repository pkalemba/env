# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [ $TERM_PROGRAM = 'vscode' ]; then
  export ZSH_TMUX_AUTOCONNECT=false
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=( $HOMEBREW_PREFIX/opt/antidote/share/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Source your static plugins file.
source ${zsh_plugins}.zsh
# Load the oh-my-zsh's library.
export MUSIC_APP="Music"

export ZSH_TMUX_AUTOSTART=true
unset GREP_OPTIONS && GREP_OPTIONS="--color=auto"
alias vim=nvim
alias nano=nvim
alias k=kubectl
alias terraform=tofu
alias fuu='sudo `fc -n -l -1`'
alias cp="rsync -ah --progress"
function cd {
    builtin cd "$@" && ls -F
    }
function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf "$1"    ;;
            *.tar.gz)    tar xvzf "$1"    ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"     ;;
            *.tbz2)      tar xvjf "$1"    ;;
            *.tgz)       tar xvzf "$1"    ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}
function authme() {
  ssh "$1" 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' \
    < ~/.ssh/id_rsa.pub
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.zsh_aliases
[ -f `which bat` ] && alias cat=bat
[ -f `which eza` ] && alias ls=eza

eval "$(atuin init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
