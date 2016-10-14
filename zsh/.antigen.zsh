source ~/.antigen/repos/antigen/antigen.zsh
antigen use prezto                                                              # ZDOTDIR is set here
# mollifier/anyframe mollifier/zload uvaes/fzf-marks mafredri/zsh-async
antigen bundle Tarrasch/zsh-colors
[[ $OSTYPE == *darwin* ]] && \
  antigen bundle unixorn/tumult.plugin.zsh && unalias vi && unalias vim
# antigen bundle hchbaw/auto-fu.zsh
# antigen bundle paulhybryant/myzsh --loc=enabled/

declare -a pmodules
zstyle ':prezto:environment:termcap' 'color' 'yes'
zstyle ':prezto:module:syntax-highlighting' 'color' 'yes'
zstyle ':prezto:module:editor' 'key-bindings' 'vi'
zstyle ':prezto:module:autosuggestions' color 'yes'
pmodules=(environment autosuggestions directory helper editor completion git \
  homebrew fasd history history-substring-search syntax-highlighting linux osx \
  tmux dpkg prompt fzf custom)                                                  # Order matters!
pmodload "${pmodules[@]}" && unset pmodules
