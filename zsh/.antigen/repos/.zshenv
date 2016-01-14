# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Non-interactive environment variabbles should be defined in zshenv

declare -U path fpath manpath
if [[ "$OSTYPE" == "darwin"* ]]; then
  declare -xg BREWVERSION="homebrew"
  declare -xg BREWHOME="$HOME/.$BREWVERSION"
  declare -xg CMDPREFIX="g"
  path=(/opt/local/bin /opt/local/sbin $path)
  # Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
  export GHC_DOT_APP="/opt/homebrew-cask/Caskroom/ghc/7.10.2-r0/ghc-7.10.2.app"
  if [ -d "$GHC_DOT_APP" ]; then
    path=(~/.cabal/bin ${GHC_DOT_APP}/Contents/bin)
  fi
  declare -xg EDITOR='mvim -v'
else
  declare -xg BREWVERSION="linuxbrew"
  declare -xg BREWHOME="$HOME/.$BREWVERSION"
  declare -xg CMDPREFIX=""
  declare -xg EDITOR='vim'
fi

path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin ~/.cabal/bin $path)
fpath=(~/.zlib ${fpath[@]})
autoload -Uz -- ~/.zlib/[^_]*(:t)

alias date='${CMDPREFIX}\date'
alias dircolors='${CMDPREFIX}\dircolors'
alias ls='${CMDPREFIX}\ls --color=auto'
alias mktemp='${CMDPREFIX}\mktemp'
alias sed='${CMDPREFIX}\sed'
alias stat='${CMDPREFIX}\stat'
alias tac='${CMDPREFIX}\tac'
alias rm='${CMDPREFIX}\trash -v'
alias xargs='${CMDPREFIX}\xargs'
zstyle ":registry:var:prefix-width" registry 10

# Local configurations
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
