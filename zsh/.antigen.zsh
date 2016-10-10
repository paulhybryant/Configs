source ~/.antigen/repos/antigen/antigen.zsh
antigen use prezto                                                              # ZDOTDIR is set here
# mollifier/anyframe mollifier/zload uvaes/fzf-marks mafredri/zsh-async
antigen bundle Tarrasch/zsh-colors
antigen bundle unixorn/tumult.plugin.zsh
unalias vi
unalias vim
# antigen bundle hchbaw/auto-fu.zsh

declare -a pmodules
zstyle ':prezto:environment:termcap' 'color' 'yes'
zstyle ':prezto:module:syntax-highlighting' 'color' 'yes'
zstyle ':prezto:module:editor' 'key-bindings' 'vi'
pmodules=(environment directory helper editor completion git homebrew fasd \
  history syntax-highlighting linux osx tmux dpkg prompt fzf custom)            # Order matters!
# history syntax-highlighting clipboard linux osx tmux dpkg prompt fzf custom)  # Order matters!
pmodload "${pmodules[@]}" && unset pmodules
