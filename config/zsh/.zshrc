export TERM=xterm-256color
# zstyle :compinstall filename '/home/alex/.config/zsh/.zshrc'

# Set up the prompt
autoload -U colors && colors

autoload -Uz prompt
if [[ -v IN_NIX_SHELL ]]
then
  PROMPT="%B%{$fg[blue]%}# nix shell"$'\n'"; %b"
else
  PROMPT="%B%{$fg[blue]%}; %b"
fi

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

setopt extendedglob
unsetopt beep

autoload zmv

# fpath=($HOME/.local/bin/completions $fpath)

# Use modern completion system
autoload -Uz compinit
compinit
_comp_options+=(globdots)


zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' menu select
zmodload zsh/complist

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
      [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init

# alias vi="nvim"
# alias vim="nvim"

alias ls="ls --color=auto --hyperlink=auto"

# export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/lab10/bin:$PATH"
export PATH="$HOME/software/devkitPro/buildscripts-devkitPPC_r46.1/opt/devkitpro/tools/bin:$PATH"

export AFL_PIZZA_MODE=1

test -r /home/alex/.opam/opam-init/init.sh && . /home/alex/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
#last
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
