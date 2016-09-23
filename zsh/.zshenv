# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell
declare -U path fpath manpath
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ -d "$HOME/.homebrew" ]]; then
    declare -xg BREWHOME="$HOME/.homebrew"
  else
    declare -xg BREWHOME="/usr/local"
  fi
  declare -xg BREWVERSION="homebrew" CMDPREFIX="g"
  path=(/opt/local/bin /opt/local/sbin ${path[@]})
  # Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
  # GHC_DOT_APP="/opt/homebrew-cask/Caskroom/ghc/7.10.2-r0/ghc-7.10.2.app"
  # [[ -d "$GHC_DOT_APP" ]] && export GHC_DOT_APP && \
    # path=(~/.cabal/bin ${GHC_DOT_APP}/Contents/bin ${path[@]})
else
  declare -xg BREWVERSION="linuxbrew" BREWHOME="$HOME/.linuxbrew" CMDPREFIX=""
fi
declare -xg EDITOR='vim' VISUAL="vim"

path=(~/.local/bin $BREWHOME/opt/go/libexec/bin ${path[@]})
manpath=($BREWHOME/opt/coreutils/libexec/gnuman \
  $BREWHOME/opt/findutils/libexec/gnuman ${manpath[@]})
fpath=(~/.zlib ${fpath[@]}) && autoload -Uz -- ~/.zlib/[^_]*(:t)
if [[ "$BREWHOME" != "/usr/local" ]]; then
  path=($BREWHOME/bin $BREWHOME/sbin ${path[@]})
fi

alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias sed='${CMDPREFIX}\sed'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
alias rm='${CMDPREFIX}\trash -v'
alias xargs='${CMDPREFIX}\xargs'
alias find='${CMDPREFIX}\find'
zstyle ":registry:var:prefix-width" registry 10

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local                              # Local configurations
