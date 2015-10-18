# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Use PROFILING='y' zsh to profile the startup time
if [[ -n ${PROFILING+1} ]]; then
  echo "Profiling result in /tmp/zstartup.profile.$$"
  # set the trace prompt to include seconds, nanoseconds, script name and line number
  # This is GNU date syntax; by default Macs ship with the BSD date program, which isn't compatible
  # PS4='+$(date "+%s:%N") %N:%i> '
  zmodload zsh/datetime
  PS4='+$EPOCHREALTIME %N:%i> '
  # save file stderr to file descriptor 3 and redirect stderr (including trace
  # output) to a file with the script's PID as an extension
  exec 3>&2 2> /tmp/startlog.$$
  # set options to turn on tracing and expansion of commands contained in the prompt
  setopt xtrace prompt_subst
fi

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

# Local configurations
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [[ -d ~/.antigen/repos/antigen ]]; then
  source ~/.antigen/repos/antigen/antigen.zsh

  mymodules=(colors file git net util)
  for module in ${mymodules}; do
    antigen bundle git@github.com:paulhybryant/Configs.git --loc=zsh/.zsh/modules/${module}.zsh
  done

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
  pmodules=(environment terminal editor history directory completion prompt \
    command-not-found fasd git syntax-highlighting history-substring-search \
    homebrew python ssh tmux)
  os::OSX && pmodules+=(osx)
  for module in ${pmodules}; do
    # antigen bundle sorin-ionescu/prezto --loc=modules/${module}
    antigen bundle sorin-ionescu/prezto modules/${module}
  done
  unset pmodules

  # antigen use oh-my-zsh
  # antigen bundle --loc=lib
  # antigen bundle robbyrussell/oh-my-zsh lib/git.zsh
  # antigen bundle robbyrussell/oh-my-zsh --loc=lib/git.zsh
  # antigen theme candy
  # antigen theme robbyrussell/oh-my-zsh themes/candy

  mymodules=(options keys aliases)
  for module in ${mymodules}; do
    antigen bundle git@github.com:paulhybryant/Configs.git --loc=zsh/.zsh/modules/${module}.zsh
  done
  unset modules

  # Tell antigen that you're done.
  antigen apply
fi
