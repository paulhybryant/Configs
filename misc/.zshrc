source "$HOME/.antigen.zsh"

antigen use oh-my-zsh
antigen bundle sorin-ionescu/prezto

# Tell antigen that you're done.
antigen apply

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
