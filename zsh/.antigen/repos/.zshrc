# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# In OSX, /etc/zprofile will be loaded before this zshrc. The path_helper binary
# in OSX will reorder the entries in $PATH, causing problems.
path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin $path)

# Use PROFILING='logfile' zsh to profile the startup time
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

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -xg HELPDIR="$BREWHOME/share/zsh/help"
declare -xg VISUAL="$EDITOR"
declare -xg GIT_EDITOR="$EDITOR"
declare -xg GREP_OPTIONS='--color=auto'
declare -xg LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen `
  `--no-init --raw-control-chars"
declare -xg PAGER='most'
# export PAGER=vimpager
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

autoload -Uz bashcompinit && bashcompinit

source ~/.antigen/repos/antigen/antigen.zsh
# zload automatically reload a file containing functions. However, it achieves
# this using pre_cmd functions, which is too heavy. Ideally should only check
# the modification time of the file.
# antigen bundle mollifier/zload

# Wrapper for peco/percol/fzf
# antigen bundle mollifier/anyframe

local pmodules
zstyle ':prezto:environment:termcap' color yes
zstyle ':prezto:module:syntax-highlighting' color yes
zstyle ':completion:*' show-completer true
zstyle ':prezto:module:prompt' theme 'powerline-shell'
zstyle ':prezto:module:editor' key-bindings 'vi'
# Order matters!
pmodules=(environment directory helper editor completion git homebrew fasd \
  history syntax-highlighting clipboard linux osx tmux dpkg prompt fzf custom)
zstyle ':prezto:load' pmodule ${pmodules[@]}

# ZDOTDIR is set here
antigen use prezto
# pmodload "${pmodules[@]}"
unset pmodules

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

# antigen apply

if zstyle -t ":registry:var:tty" registry 'virtual'; then
  prompt powerline-shell
  # powerline-plus is the native powerline bindings from powerline
  # powerline is the built-in powerline theme from prezto
  # prompt powerline-plus
else
  prompt clint
fi

# Local configurations
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [[ -n ${PROFILING+1} ]]; then
  exit 0
fi
