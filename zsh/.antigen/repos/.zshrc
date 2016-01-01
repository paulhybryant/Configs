# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

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

# This seems to be duplicate with the one in .zshenv but it is not! It ensures
# the homebrew bin directory are in front of the system's bin directory.
# path=(~/.zsh/bin ~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  # $BREWHOME/opt/go/libexec/bin $path)

declare -U fpath manpath
manpath=($BREWHOME/share/man ~/.zsh/man $manpath)
declare -U -T INFOPATH infopath
infopath=($BREWHOME/share/info $infopath)
brew list go > /dev/null 2>&1 && declare -xg GOPATH="$(brew --prefix go)"
brew list gnu-sed > /dev/null 2>&1 && \
  manpath=($(brew --prefix gnu-sed)/libexec/gnuman $manpath)
fpath=($BREWHOME/share/zsh-completions ~/.zsh/lib $fpath)

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -xg HELPDIR="$BREWHOME/share/zsh/help"
declare -xg EDITOR='vim'
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

if [[ -f ~/.zshrc.local.before ]]; then
  source ~/.zshrc.local.before
fi

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

  # ZDOTDIR is set here
  antigen use prezto
  local pmodules
  # Order matters!
  zstyle ':prezto:environment:termcap' color yes
  zstyle ':prezto:module:syntax-highlighting' color yes
  zstyle ':completion:*' show-completer true
  pmodules=(environment directory completion git homebrew helper fasd ssh \
    history syntax-highlighting clipboard linux osx fzf tmux dpkg prompt custom)
  pmodload "${pmodules[@]}"
  unset pmodules

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

  antigen apply
fi

# Local configurations
if [[ -f ~/.zshrc.local.after ]]; then
  source ~/.zshrc.local.after
fi

if [[ -n ${PROFILING+1} ]]; then
  exit 0
else
  if zstyle -t ":registry:var:tty" registry 'virtual'; then
    prompt powerline-shell
    # powerline-plus is the native powerline bindings from powerline
    # powerline is the built-in powerline theme from prezto
    # prompt powerline-plus
  else
    prompt clint
  fi
fi
