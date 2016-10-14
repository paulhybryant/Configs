# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell
declare -U path manpath fpath
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -d "$HOME/.homebrew" ]]; then
    declare -xg BREWHOME="$HOME/.homebrew"
  else
    declare -xg BREWHOME="/usr/local"
  fi
  declare -xg BREWVERSION="homebrew" CMDPREFIX="g"
else
  declare -xg BREWVERSION="linuxbrew" BREWHOME="$HOME/.linuxbrew" CMDPREFIX=""
fi
declare -xg EDITOR='vim' VISUAL="vim"
if [[ "$BREWHOME" != "/usr/local" ]]; then
  path=($BREWHOME/bin $BREWHOME/sbin ${path[@]})
fi

alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias find='${CMDPREFIX}\find'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias rm='${CMDPREFIX}\trash -v'
alias sed='${CMDPREFIX}\sed'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
alias xargs='${CMDPREFIX}\xargs'
zstyle ":registry:var:prefix-width" registry 10

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local                              # Local configurations
