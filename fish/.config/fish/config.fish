# Aliases
alias wc "gwc"

# Powerline prompt setup
set fish_function_path $fish_function_path "/usr/local/lib/python2.7/site-packages/powerline/bindings/fish"
powerline-setup

# Enable vi-mode
fish_vi_key_bindings

if test -e "~/.local/config.fish"
  source ~/.local/config.fish
end
