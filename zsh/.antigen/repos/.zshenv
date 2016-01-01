# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell
# Non-interactive environment variabbles should be defined in zshenv

declare -U path
if [[ "$OSTYPE" == "darwin"* ]]; then
  declare -xg BREWVERSION="homebrew"
  declare -xg BREWHOME="$HOME/.$BREWVERSION"
  declare -xg CMDPREFIX="g"
  path=(/opt/local/bin /opt/local/sbin $path)
else
  declare -xg BREWVERSION="linuxbrew"
  declare -xg BREWHOME="$HOME/.$BREWVERSION"
  declare -xg CMDPREFIX=""
fi

path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin $path)

alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias sed='${CMDPREFIX}\sed'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
if which ${CMDPREFIX}trash > /dev/null 2>&1; then
  alias rm='${CMDPREFIX}\trash -v'
else
  alias rm='command rm -v'
fi
zstyle ":registry:var:prefix-width" registry 10

# Local configurations
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
