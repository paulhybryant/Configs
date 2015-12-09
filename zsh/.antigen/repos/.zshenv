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
path=(~/.zsh/bin ~/.local/bin $BREWHOME/bin $BREWHOME/sbin $BREWHOME/opt/go/libexec/bin $path)

declare -U fpath
fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions ~/.zsh/lib $fpath)
declare -U manpath
manpath=($BREWHOME/share/man ~/.zsh/man $manpath)
declare -U -T INFOPATH infopath
infopath=($BREWHOME/share/info $infopath)
brew list go > /dev/null 2>&1 && declare -xg GOPATH="$(brew --prefix go)"
declare -U precmd_functions

declare -axg -U zsh_autoload_dir
zsh_autoload_dir=(~/.zsh/lib ${zsh_autoload_dir})
autoload -Uz zsh::autoload time::getmtime
[[ -d ~/.zsh/lib ]] && zsh::autoload ~/.zsh/lib/[^_]*(:t)

# Local configurations
if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi
