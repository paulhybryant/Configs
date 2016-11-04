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
path=(~/.local/bin ${path[@]})

# coreutils
# alias date='${CMDPREFIX}\date'
# alias dircolors='${CMDPREFIX}\dircolors'
# alias ls='${CMDPREFIX}\ls --color=auto'
# alias mktemp='${CMDPREFIX}\mktemp'
# alias stat='${CMDPREFIX}\stat'
# alias tac='${CMDPREFIX}\tac'
path=($BREWHOME/opt/coreutils/libexec/gnubin ${path[@]})

# gnu-sed
# alias sed='${CMDPREFIX}\sed'
path=($BREWHOME/opt/gnu-sed/libexec/gnubin ${path[@]})

# gnu-which
alias which='${CMDPREFIX}\which'

# gnu-tar
# alias tar='${CMDPREFIX}\tar'
path=($BREWHOME/opt/gnu-tar/libexec/gnubin ${path[@]})

# findutils
# alias find='${CMDPREFIX}\find'
# alias locate='${CMDPREFIX}\locate'
# alias updatedb='${CMDPREFIX}\updatedb'
# alias xargs='${CMDPREFIX}\xargs'
path=($BREWHOME/opt/findutils/libexec/gnubin ${path[@]})

zstyle ":registry:var:prefix-width" registry 10

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local                              # Local configurations
