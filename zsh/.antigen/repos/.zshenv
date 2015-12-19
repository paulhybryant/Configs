# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell
# Non-interactive environment variabbles should be defined in zshenv

declare -U path fpath manpath precmd_functions
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

path=(~/.zsh/bin ~/.local/bin $BREWHOME/bin $BREWHOME/sbin $BREWHOME/opt/go/libexec/bin $path)
fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions ~/.zsh/lib $fpath)
manpath=($BREWHOME/share/man ~/.zsh/man $manpath)

declare -U -T INFOPATH infopath
infopath=($BREWHOME/share/info $infopath)
brew list go > /dev/null 2>&1 && declare -xg GOPATH="$(brew --prefix go)"
brew list gnu-sed > /dev/null 2>&1 && manpath=($(brew --prefix gnu-sed)/libexec/gnuman $manpath)

alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias sed='${CMDPREFIX}\sed'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
which ${CMDPREFIX}trash > /dev/null 2>&1 && alias rm='${CMDPREFIX}\trash -v'

autoload -Uz -- add-zsh-hook ~/.zsh/lib/[^_]*(:t)

# Local configurations
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
