# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

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

  for module in colors file git net util; do
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
    command-not-found fasd git history-substring-search homebrew python ssh \
    syntax-highlighting tmux)
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

  for module in options keys aliases; do
    antigen bundle git@github.com:paulhybryant/Configs.git --loc=zsh/.zsh/modules/${module}.zsh
  done
  # Tell antigen that you're done.
  antigen apply
fi
