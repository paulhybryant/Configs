if [[ -e "$HOME/.antigen.zsh" ]]; then
  source "$HOME/.antigen.zsh"
fi

source "$HOME/.zutils/lib/configs.zsh"

# Some binary won't be available in path if only installed in brew.
# One such example is tmux.
configs::bootstrap

if [[ -e "$HOME/.zshrc.prezto" ]]; then
  source "$HOME/.zshrc.prezto"
fi

configs::config

# Local configurations
if [[ -e "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

configs::end
