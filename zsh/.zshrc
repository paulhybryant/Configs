if [[ -d "$HOME/.antigen/repos/antigen" ]]; then
  source "$HOME/.antigen/repos/antigen/antigen.zsh"

  # antigen use oh-my-zsh
  # antigen bundle --loc=lib
  antigen use prezto

  # antigen bundle robbyrussell/oh-my-zsh lib/git.zsh
  # antigen bundle robbyrussell/oh-my-zsh --loc=lib/git.zsh

  # antigen theme candy
  # antigen theme robbyrussell/oh-my-zsh themes/candy

  # Tell antigen that you're done.
  antigen apply
fi

if [[ -d "$HOME/.zutils" ]]; then
  source "$HOME/.zutils/lib/init.zsh"
  source "$HOME/.zutils/lib/configs.zsh"
  source "$HOME/.zutils/lib/util.zsh"
  configs::config
  util::start_ssh_agent "ssh-agent"

  # Local configurations
  if [[ -e "$HOME/.zshrc.local" ]]; then
    source "$HOME/.zshrc.local"
  fi

  configs::end
fi
