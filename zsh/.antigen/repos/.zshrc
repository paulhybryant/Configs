# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Use PROFILING='y' zsh to profile the startup time
if [[ -n ${PROFILING+1} ]]; then
  # set the trace prompt to include seconds, nanoseconds, script name and line
  # number This is GNU date syntax; by default Macs ship with the BSD date
  # program, which isn't compatible
  # PS4='+$(date "+%s:%N") %N:%i> '
  zmodload zsh/datetime
  PS4='+$EPOCHREALTIME %N:%i> '
  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  exec 3>&2 2> ${PROFILING}
  # set options to turn on tracing and expansion of commands contained in the
  # prompt
  setopt xtrace prompt_subst
fi

# This seems to be duplicate with the one in .zshenv but it is not! It ensures
# the homebrew bin directory are in front of the system's bin directory.
path=(~/.zsh/bin ~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin $path)

declare -U fpath manpath
manpath=($BREWHOME/share/man ~/.zsh/man $manpath)
declare -U -T INFOPATH infopath
infopath=($BREWHOME/share/info $infopath)
brew list go > /dev/null 2>&1 && declare -xg GOPATH="$(brew --prefix go)"
brew list gnu-sed > /dev/null 2>&1 && \
  manpath=($(brew --prefix gnu-sed)/libexec/gnuman $manpath)

fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions \
  ~/.zsh/lib $fpath)
autoload -Uz -- add-zsh-hook ~/.zsh/lib/[^_]*(:t)

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -xg HELPDIR="$BREWHOME/share/zsh/help"
declare -xg EDITOR='vim'
declare -xg GREP_OPTIONS='--color=auto'
declare -xg LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen `
  `--no-init --raw-control-chars"
declare -xg PAGER='most'
# export PAGER=vimpager
declare -xg MANPAGER="$PAGER"
declare -xg TERM='screen-256color'
declare -xg VISUAL="$EDITOR"
declare -xg XDG_CACHE_HOME="$HOME/.cache"
declare -xg XDG_CONFIG_HOME="$HOME/.config"
declare -xg XDG_DATA_HOME="$HOME/.local/share"
declare -xg HISTSIZE=50000
declare -xg SAVEHIST=60000
declare -xg GIT_EDITOR="$EDITOR"

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef
# Prevent Ctrl + D to send eof so that it can be rebind
# stty eof ''
# stty eof undef
# bindkey -s '^D' 'exit^M'

if [[ -f ~/.zshrc.local.before ]]; then
  source ~/.zshrc.local.before
fi

# Defaults to file completion
# Adding _files after fasd completer doesn't work, so this has to be put before
# loading prezto
zstyle -a ':completion:*' completer _cur_completers
zstyle ':completion:*' completer $_cur_completers _complete _files

if [[ -d ~/.antigen/repos/antigen ]]; then
  source ~/.antigen/repos/antigen/antigen.zsh

  # zload automatically reload a file containing functions. However, it achieves
  # this using pre_cmd functions, which is too heavy. Ideally should only check
  # the modification time of the file.
  # TODO: Reuse this idea and make it lightweight.
  # antigen bundle mollifier/zload

  # Wrapper for peco/percol/fzf
  # antigen bundle mollifier/anyframe

  # antigen bundle mollifier/cd-bookmark
  antigen bundle mollifier/cd-gitroot

  antigen use prezto
  local pmodules
  # pmodules=(tmux command-not-found completion )
  # Order matters!
  zstyle ':prezto:module:syntax-highlighting' color yes
  pmodules=(environment completion git homebrew helper fasd ssh \
    syntax-highlighting clipboard)
  if [[ -z ${PROFILING+1} ]]; then
    pmodules+=(prompt)
    add-zsh-hook -Uz zshexit tmux::try-switch
    # trap 'tmux::try-switch' EXIT
  fi
  os::OSX && pmodules+=(osx)
  # zstyle ':prezto:module:syntax-highlighting' highlighters \
    # 'main' \
    # 'brackets' \
    # 'pattern' \
    # 'cursor' \
    # 'root'
  # zstyle ':prezto:module:syntax-highlighting' styles \
    # 'builtin' 'bg=blue' \
    # 'command' 'bg=blue' \
    # 'function' 'bg=blue'
  pmodload "${pmodules[@]}"
  unset pmodules
  zstyle ':completion:*' show-completer true

  # Alternative 1
  # zstyle ':prezto:load' pmodule ${pmodules}
  # zstyle ':prezto:module:editor' key-bindings 'vi'

  # Alternative 2
  # for module in ${pmodules}; do
    # antigen bundle sorin-ionescu/prezto --loc=modules/${module}
    # antigen bundle sorin-ionescu/prezto modules/${module}
  # done

  # antigen bundle --loc=lib
  # antigen bundle robbyrussell/oh-my-zsh lib/git.zsh
  # antigen bundle robbyrussell/oh-my-zsh --loc=lib/git.zsh
  # antigen theme robbyrussell/oh-my-zsh themes/candy

  # antigen use oh-my-zsh
  # antigen bundle git directories
  # antigen theme robbyrussell

  antigen bundle https://github.com/paulhybryant/dotfiles.git \
    --loc=zsh/.zsh/init.zsh
  antigen apply
fi
autoload -Uz bashcompinit && bashcompinit

declare -xg HISTFILE="$ZDOTDIR/.zhistory"
declare -xg HIST_STAMPS='yyyy-mm-dd'

# prompt paradox
# zstyle ':prezto:module:git:info:branch' format ' %b'
# zstyle ':prezto:module:git:info:action' format ''
# zstyle ':prezto:module:git:info:ahead' format ' ⬆ %A'
# zstyle ':prezto:module:git:info:stashed' format ''
# zstyle ':prezto:module:git:info:modified' format ''
# zstyle ':prezto:module:git:info:dirty' format ''

# Local configurations
if [[ -f ~/.zshrc.local.after ]]; then
  source ~/.zshrc.local.after
fi

compdef _ta tmux::attach
autoload -Uz _ta _ta-sessions

if [[ -n ${PROFILING+1} ]]; then
  exit 0
fi
