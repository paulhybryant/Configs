# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

declare -U path
declare -U fpath
declare -U precmd_functions
if [[ "$OSTYPE" == "darwin"* ]]; then
  declare -x BREWVERSION="homebrew"
  declare -x BREWHOME="$HOME/.$BREWVERSION"
  declare -x CMDPREFIX="g"
  path=(/opt/local/bin /opt/local/sbin $path)
else
  declare -x BREWVERSION="linuxbrew"
  declare -x BREWHOME="$HOME/.$BREWVERSION"
  declare -x CMDPREFIX=""
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
declare -x XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
declare -x HELPDIR="$BREWHOME/share/zsh/help"
declare -x EDITOR='vim'
declare -x GREP_OPTIONS='--color=auto'
declare -x LESS='--ignore-case --quiet --chop-long-lines --quit-if-one-screen --no-init --raw-control-chars'
declare -x PAGER='most'
# export PAGER=vimpager
declare -x PREFIXWIDTH=10
declare -x MANPAGER="$PAGER"
declare -x TERM='screen-256color'
declare -x VISUAL='vim'
declare -x XDG_CACHE_HOME="$HOME/.cache"
declare -x XDG_CONFIG_HOME="$HOME/.config"
declare -x XDG_DATA_HOME="$HOME/.local/share"
declare -x HISTSIZE=50000
declare -x SAVEHIST=60000
declare -x HISTFILE="$HOME/.zhistory"
declare -x HIST_STAMPS='yyyy-mm-dd'

brew list go > /dev/null 2>&1 && declare -x GOPATH="$(brew --prefix go)"
