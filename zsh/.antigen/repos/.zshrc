# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# /etc/zshenv will be loaded before zshrc. In OSX, the path_helper binary
# is called in /etc/zshenv, which reorders the entries in $PATH, causing problems.
path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin $path)

# Use PROFILING='logfile' zsh to profile the startup time
if [[ -n ${PROFILING+1} ]]; then
  # set the trace prompt to include seconds, nanoseconds, script name and line
  # number.
  zmodload zsh/datetime
  PS4='+$EPOCHREALTIME %N:%i> '
  # PS4='+$(date "+%s:%N") %N:%i> '
  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  exec 3>&2 2> ${PROFILING}
  # set options to turn on tracing and expansion of commands in the prompt
  setopt xtrace prompt_subst
fi

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -xg HELPDIR="$BREWHOME/share/zsh/help"
declare -xg VISUAL="$EDITOR"
declare -xg GIT_EDITOR="$EDITOR"
# Adding -H breaks scripts uses grep without unsetting GREP_OPTIONS
declare -xg GREP_OPTIONS="--color=auto"
declare -xg LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen `
  `--no-init --raw-control-chars"
declare -xg PAGER='most'
declare -xg MANPAGER="$PAGER"
declare -xg TERM='screen-256color'
declare -xg XDG_CACHE_HOME="$HOME/.cache"
declare -xg XDG_CONFIG_HOME="$HOME/.config"
declare -xg XDG_DATA_HOME="$HOME/.local/share"

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef
# Prevent Ctrl + D to send eof so that it can be rebind
# stty eof ''
# stty eof undef
# bindkey -s '^D' 'exit^M'

source ~/.antigen/repos/antigen/antigen.zsh

# ZDOTDIR is set here
antigen use prezto

# Wrapper for peco/percol/fzf
# antigen bundle mollifier/anyframe
antigen bundle mollifier/zload
antigen bundle uvaes/fzf-marks
antigen bundle mafredri/zsh-async
antigen bundle Tarrasch/zsh-colors

local pmodules
zstyle ':prezto:environment:termcap' color yes
zstyle ':prezto:module:syntax-highlighting' color yes
zstyle ':completion:*' show-completer true
zstyle ':prezto:module:editor' key-bindings 'vi'
# Order matters!
pmodules=(environment directory helper editor completion git homebrew fasd \
  history syntax-highlighting clipboard linux osx tmux dpkg prompt fzf custom)
# zstyle ':prezto:load' pmodule ${pmodules[@]}
pmodload "${pmodules[@]}"
unset pmodules

if [[ -f ~/.antigen/.local ]]; then
  source ~/.antigen/.local
fi

antigen apply

# Local configurations
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [[ -n ${PROFILING+1} ]]; then
  exit 0
fi
