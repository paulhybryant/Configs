# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

[[ -d ~/.zsh/lib ]] && autoload -Uz -- ~/.zsh/lib/[^_]*(:t)
[[ -d ~/.zsh/functions ]] && autoload -Uz -- ~/.zsh/functions/[^_]*(:t)
autoload -Uz bashcompinit && bashcompinit
# zstyle ":completion:*" show-completer true

# Use PROFILING='y' zsh to profile the startup time
if [[ -n ${PROFILING+1} ]]; then
  local _profile_log="/tmp/zsh.profile"
  # set the trace prompt to include seconds, nanoseconds, script name and line number
  # This is GNU date syntax; by default Macs ship with the BSD date program, which isn't compatible
  # PS4='+$(date "+%s:%N") %N:%i> '
  zmodload zsh/datetime
  PS4='+$EPOCHREALTIME %N:%i> '
  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  exec 3>&2 2> ${_profile_log}
  # set options to turn on tracing and expansion of commands contained in the prompt
  setopt xtrace prompt_subst
fi

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef
# Prevent Ctrl + D to send eof so that it can be rebind
# stty eof ''
# stty eof undef
# bindkey -s '^D' 'exit^M'

if [[ -d ~/.antigen/repos/antigen ]]; then
  source ~/.antigen/repos/antigen/antigen.zsh

  # zload automatically reload a file containing functions. However, it achieves
  # this using pre_cmd functions, which is too heavy. Ideally should only check
  # the modification time of the file.
  # TODO: Reuse this idea and make it lightweight.
  # antigen bundle mollifier/zload

  zstyle ':prezto:module:editor' key-bindings 'vi'
  # Alternative (from zpreztorc), order matters!
  # This has to be put before antigen use prezto (which sources root init.zsh
  # for prezto)
  # zstyle ':prezto:load' pmodule \
    # 'environment' \
    # 'terminal' \
    # 'editor' \
    # 'history' \
    # 'directory' \
    # 'spectrum' \
    # 'utility' \
    # 'completion' \
    # 'prompt'

  antigen use prezto
  local pmodules
  # Order matters! (per zpreztorc)
  pmodules=(environment terminal editor history directory completion fasd git \
    command-not-found syntax-highlighting history-substring-search homebrew \
    ssh tmux)
  os::OSX && pmodules+=(osx)
  for module in ${pmodules}; do
    # antigen bundle sorin-ionescu/prezto --loc=modules/${module}
    antigen bundle sorin-ionescu/prezto modules/${module}
  done
  unset pmodules

  antigen bundle git@github.com:paulhybryant/Configs.git --loc=zsh/.zsh/init.zsh

  # antigen use oh-my-zsh
  # antigen bundle --loc=lib
  # antigen bundle robbyrussell/oh-my-zsh lib/git.zsh
  # antigen bundle robbyrussell/oh-my-zsh --loc=lib/git.zsh
  # antigen theme candy
  # antigen theme robbyrussell/oh-my-zsh themes/candy

  # Tell antigen that you're done. It will call compinit again, need to evaluate
  # whether it slows startup down.
  antigen apply
fi

# Local configurations
if [[ -f ~/.zshrc.google ]]; then
  source ~/.zshrc.google
fi

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
trap 'util::tmux-try-switch' EXIT

if [[ -n ${PROFILING+1} ]]; then
  exit 0
fi
