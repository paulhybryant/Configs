# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

if [[ "$OSTYPE" == "darwin"* ]]; then
  export BREWVERSION="homebrew"
  export BREWHOME="$HOME/.$BREWVERSION"
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  export CMDPREFIX="g"
  export SSH_AGENT_NAME='gnubby-ssh-agent'
  alias updatedb="/usr/libexec/locate.updatedb"
else
  export BREWVERSION="linuxbrew"
  export BREWHOME="$HOME/.$BREWVERSION"
  export SSH_AGENT_NAME='ssh-agent'
fi

export PATH="$HOME/.zsh/bin:$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$BREWHOME/opt/go/libexec/bin:$PATH"
export MANPATH="$BREWHOME/share/man:$HOME/.zsh/man:$MANPATH"
export INFOPATH="$BREWHOME/share/info:$INFOPATH"
fpath+=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions)

# Don't enable the following line, it will screw up HOME and END key in tmux
# export TERM=xterm-256color
# If it is really need for program foo, create an alias like this
# alias foo='TERM=xterm-256color foo'
export XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
export HELPDIR="$BREWHOME/share/zsh/help"
export EDITOR='vim'
export GREP_OPTIONS='--color=auto'
export PAGER='most'
# export PAGER=vimpager
export PREFIXWIDTH=10
export MANPAGER="$PAGER"
export TERM='screen-256color'
export VISUAL='vim'
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export HISTSIZE=50000
export SAVEHIST=60000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS='yyyy-mm-dd'

autoload -Uz bashcompinit && bashcompinit
# zstyle ":completion:*" show-completer true
