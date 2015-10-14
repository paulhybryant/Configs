# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# zshoptions {{{
# Options are not ordered alphabetically, but their order in zsh man page
# Changing Directories
setopt AUTOCD                                                                  # Switching directories for lazy people
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT

# Completion
setopt ALWAYS_TO_END                                                            # When complete from middle, move cursor
setopt AUTO_LIST
setopt AUTO_MENU                                                                # Automatically use menu completion after the second consecutive request for completion
setopt AUTO_PARAM_SLASH
setopt COMPLETE_ALIASES                                                         # Prevent aliases from being internally substituted before completion is attempted
setopt COMPLETE_IN_WORD                                                         # Not just at the end
setopt GLOB_COMPLETE
setopt LIST_AMBIGUOUS
setopt LIST_TYPES

# Expansion and Globbing
setopt EXTENDED_GLOB                                                            # Weird &amp; wacky pattern matching - yay zsh!
setopt NO_NOMATCH                                                               # pass through '*' if globbing fails
setopt CASEMATCH                                                                # Whether the regex comparison (e.g. =~) will match case

# History
setopt APPEND_HISTORY
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS                                                     # Do not enter command lines into the history list if they are duplicates of the previous event
setopt HIST_IGNORE_DUPS                                                         # ignore duplication command history list
setopt HIST_IGNORE_SPACE                                                        # Remove command lines from the history list when the first character on the line is a space
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS                                                       # Remove superfluous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY                                                              # When using ! cmds, confirm first
setopt NO_INC_APPEND_HISTORY
setopt SHARE_HISTORY                                                            # share command history data

# Input/Output
setopt ALIASES
setopt CLOBBER
setopt CORRECT
setopt INTERACTIVE_COMMENTS                                                     # Escape commands so I can use them later
setopt PRINT_EXIT_VALUE                                                         # Alert me if something's failed
setopt SHORT_LOOPS

# Job Control
setopt CHECK_JOBS
setopt NOHUP                                                                    # Don't kill background jobs when I logout

# Prompting
setopt PROMPT_BANG
setopt NO_PROMPT_CR                                                             # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
setopt PROMPT_PERCENT
setopt PROMPT_SUBST

# Scripts and Functions
setopt LOCAL_OPTIONS                                                            # Allow setting function local options with 'setopt localoptions foo nobar'

# Shell Emulation
setopt NO_CONTINUE_ON_ERROR

# Shell State
setopt VI                                                                       # Use vi key bindings in ZSH
# }}}

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

alias date='${CMDPREFIX}date'
alias ls='${CMDPREFIX}ls --color=tty'
alias mktemp='${CMDPREFIX}mktemp'
alias stat='${CMDPREFIX}stat'
alias stow-'stow -v'

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
case $HIST_STAMPS in
  'mm/dd/yyyy') alias history='fc -fl 1' ;;
  'dd.mm.yyyy') alias history='fc -El 1' ;;
  'yyyy-mm-dd') alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

alias grepc='grep -C 5 '
alias info='info --vi-keys'
alias nvim='NVIM=nvim nvim'
alias tl='tmux list-sessions'
alias tmux='TERM=screen-256color tmux -2'
(( $+aliases[run-help] )) && unalias run-help                                   # Use built-in run-help to use online help
autoload run-help                                                               # Use the zsh built-in run-help function, run-help is aliased to man by default

autoload -Uz bashcompinit && bashcompinit
zstyle ":completion:*" show-completer true
