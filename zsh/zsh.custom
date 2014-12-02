# Modeline and Notes {{
# vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:
# }}

# General {{

# Turn on vi mode by default.
set -o vi
# Enalbe Ctrl-R for revert search in vi mode
bindkey "^R" history-incremental-search-backward

# Allow pass Ctrl + C(Q) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

# Don't enable the following line, it will screw up HOME and END key in tmux
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
# export TERM=xterm-256color
export GREP_OPTIONS='--color=auto'

function powerline_precmd() {
  export PS1="$(powerline-shell.py --colorize-hostname $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

install_powerline_precmd

# }}

# Aliases {{

# tmux
alias tmux="TERM=screen-256color-bce tmux -2"
alias ta="tmux attach -t "
alias tls="tmux ls"

# misc
# Print function definition
alias pfd="declare -f"
alias rm="rm -v"

# }}

# functions {{

function ll() {
  ls -lh $*
  ls -l $* | awk -f $HOME/.utils/lldu.awk
}

function la() {
  ls -alF $*
  ls -alF $* | awk -f $HOME/.utils/lldu.awk
}

function myssh() {
  ssh $* -t "export SSH_OS=\"`uname`\"; bash"
}

# }}

# Additional configurations to load {{

# RVM
if [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi

# Tmuxinator
if [ -e "~/.tmuxinator.zsh" ]; then
  source ~/.tmuxinator.zsh
fi

# }}
