# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Non-interactive environment variabbles should be defined in zshenv
declare -U path fpath manpath
if [[ "$OSTYPE" == "darwin"* ]]; then
  declare -xg BREWVERSION="homebrew" BREWHOME="$HOME/.homebrew" CMDPREFIX="g" \
    EDITOR='mvim -v' VISUAL='mvim -v'
  path=(/opt/local/bin /opt/local/sbin ${path[@]})
  # Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
  export GHC_DOT_APP="/opt/homebrew-cask/Caskroom/ghc/7.10.2-r0/ghc-7.10.2.app"
  [[ -d "$GHC_DOT_APP" ]] && path=(~/.cabal/bin ${GHC_DOT_APP}/Contents/bin)
else
  declare -xg BREWVERSION="linuxbrew" BREWHOME="$HOME/.linuxbrew" CMDPREFIX="" \
    EDITOR='vim' VISUAL="vim"
fi

path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
  $BREWHOME/opt/go/libexec/bin ~/.cabal/bin ${path[@]})
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

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local                              # Local configurations
