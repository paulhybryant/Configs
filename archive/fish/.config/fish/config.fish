# Plugins
# fzf paths string edc/bass debug
# omf/balias omf/brew omf/osx omf/pbcopy omf/peco omf/percol omf/ssh omf/tmux
# omf/fasd omf/theme-bobthefish

# Aliases
# alias wc "gwc"
alias j "z"

# Abbreviations
abbr gcm "git commit -a -m"

# Powerline prompt setup
# set fish_function_path $fish_function_path "$BREWHOME/lib/python2.7/site-packages/powerline/bindings/fish"
# powerline-setup

# omf/theme-bobthefish
set -g theme_display_git_ahead_verbose yes
set -g theme_display_hg yes
set -g theme_display_cmd_duration yes
set -g theme_show_exit_status yes
set -g theme_color_scheme dark
set -g theme_newline_cursor yes

# Enable vi-mode
fish_vi_key_bindings

if test -e "~/.local/config.fish"
  source ~/.local/config.fish
end
