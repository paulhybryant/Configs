# Plugins
# omf/balias omf/brew omf/osx omf/pbcopy omf/peco omf/percol omf/ssh omf/tmux

# Aliases
# alias wc "gwc"
alias j "z"

# Abbreviations
abbr gcm "git commit -a -m"

# Powerline prompt setup
set fish_function_path $fish_function_path "$BREWHOME/lib/python2.7/site-packages/powerline/bindings/fish"
powerline-setup

# Enable vi-mode
fish_vi_key_bindings

if test -e "~/.local/config.fish"
  source ~/.local/config.fish
end
