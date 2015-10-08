source "$HOME/.antigen.zsh"

source "$HOME/.zutils/lib/configs.zsh"

# Some binary won't be available in path if only installed in brew.
# One such example is tmux.
configs::bootstrap

source "$HOME/.zshrc.prezto"

configs::config

# Local configurations
if [[ -e "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

configs::end
