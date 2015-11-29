# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

declare -U path
declare -U fpath
declare -U precmd_functions
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
declare -U manpath
manpath=($BREWHOME/share/man ~/.zsh/man $manpath)
declare -U -T INFOPATH infopath
infopath=($BREWHOME/share/info $infopath)
fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions ~/.zsh/lib $fpath)

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -xg HELPDIR="$BREWHOME/share/zsh/help"
declare -xg EDITOR='vim'
declare -xg GREP_OPTIONS='--color=auto'
declare -xg LESS='--ignore-case --quiet --chop-long-lines --quit-if-one-screen --no-init --raw-control-chars'
declare -xg PAGER='most'
# export PAGER=vimpager
declare -xg PREFIXWIDTH=10
declare -xg MANPAGER="$PAGER"
declare -xg TERM='screen-256color'
declare -xg VISUAL='vim'
declare -xg XDG_CACHE_HOME="$HOME/.cache"
declare -xg XDG_CONFIG_HOME="$HOME/.config"
declare -xg XDG_DATA_HOME="$HOME/.local/share"
declare -xg HISTSIZE=50000
declare -xg SAVEHIST=60000
declare -xg HISTFILE="$HOME/.zhistory"
declare -xg HIST_STAMPS='yyyy-mm-dd'

brew list go > /dev/null 2>&1 && declare -xg GOPATH="$(brew --prefix go)"
