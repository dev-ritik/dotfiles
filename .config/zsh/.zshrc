# Flex on the ubuntu users
neofetch
stty stop undef   # Disable ctrl-s to freeze terminal.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt autocd   # Automatically cd into typed directory.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
# don't put lines starting with space in the history.
HISTCONTROL=ignorespace
export HISTIGNORE='&:bg:fg:ll:h'
export HISTIGNORE='${HISTIGNORE:+$HISTIGNORE:}la:ll:lah:lat:;a:-:fg:bg:j:sync:esu:rma:rmp:fol:pfol'
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
export HISTIGNORE='pwd:cd:ls:ls -l:'       # ignore commands given

# Basic auto/tab complete:
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
autoload -U compinit
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)   # Include hidden files.

# vi mode
bindkey -v
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

export KEYTIMEOUT=1

# Vim Normal mode: ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# Vim Normal mode: ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# # If not running interactively, don't do anything
# # [[ $- != *i* ]] && return

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

# Control bindings for programs
bindkey -s "^o" "lc\n"

# Ctrl left & right keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/shell/*; do source "$f"; done

# Load zsh-syntax-highlighting
source "$XDG_CONFIG_HOME"/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# Zsh autocompletion using history
source "$XDG_CONFIG_HOME"/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source "$XDG_CONFIG_HOME"/zsh/powerlevel10k/powerlevel10k.zsh-theme

source /etc/zsh_command_not_found

for f in "$XDG_CONFIG_HOME"/zsh/plugins/*; do source "$f"; done

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
