# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

bindkey -d                                                                      # Unbind all keys
# antigen {{{
if [[ -d ~/.antigen/repos/antigen ]]; then
  source ~/.antigen/repos/antigen/antigen.zsh

  antigen use prezto
  for module in fasd git; do
    # antigen bundle sorin-ionescu/prezto --loc=modules/${module}
    antigen bundle sorin-ionescu/prezto modules/${module}
  done

  # antigen use oh-my-zsh
  # antigen bundle --loc=lib
  # antigen bundle robbyrussell/oh-my-zsh lib/git.zsh
  # antigen bundle robbyrussell/oh-my-zsh --loc=lib/git.zsh
  # antigen theme candy
  # antigen theme robbyrussell/oh-my-zsh themes/candy

  # Tell antigen that you're done.
  antigen apply
fi
# }}}
# zshoptions {{{
# Options are not ordered alphabetically, but their order in zsh man page
# Changing Directories
setopt AUTOCD                                                                # Switching directories for lazy people
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT

# Completion
setopt ALWAYS_TO_END                                                          # When complete from middle, move cursor
setopt AUTO_LIST
setopt AUTO_MENU                                                              # Automatically use menu completion after the second consecutive request for completion
setopt AUTO_PARAM_SLASH
setopt COMPLETE_ALIASES                                                       # Prevent aliases from being internally substituted before completion is attempted
setopt COMPLETE_IN_WORD                                                       # Not just at the end
setopt GLOB_COMPLETE
setopt LIST_AMBIGUOUS
setopt LIST_TYPES

# Expansion and Globbing
setopt EXTENDED_GLOB                                                          # Weird &amp; wacky pattern matching - yay zsh!
setopt NONOMATCH                                                              # pass through '*' if globbing fails
# setopt NOCASEMATCH                                                          # Whether the regex comparison (e.g. =~) will match case

# History
setopt APPEND_HISTORY
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS                                                   # Do not enter command lines into the history list if they are duplicates of the previous event
setopt HIST_IGNORE_DUPS                                                       # ignore duplication command history list
setopt HIST_IGNORE_SPACE                                                      # Remove command lines from the history list when the first character on the line is a space
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS                                                     # Remove superfluous blanks from each command line being added to the history list
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY                                                            # When using ! cmds, confirm first
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY                                                          # share command history data

# Input/Output
setopt ALIASES
setopt CLOBBER
setopt CORRECT
setopt INTERACTIVE_COMMENTS                                                   # Escape commands so I can use them later
setopt PRINT_EXIT_VALUE                                                       # Alert me if something's failed
setopt SHORT_LOOPS

# Job Control
setopt CHECK_JOBS
setopt NOHUP                                                                  # Don't kill background jobs when I logout

# Prompting
setopt PROMPT_BANG
# setopt NO_PROMPT_CR                                                         # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
setopt PROMPT_PERCENT
setopt PROMPT_SUBST

# Scripts and Functions
setopt LOCAL_OPTIONS                                                          # Allow setting function local options with 'setopt localoptions foo nobar'

# Shell Emulation
setopt NOCONTINUE_ON_ERROR

# Shell State
setopt VI                                                                     # Use vi key bindings in ZSH
# }}}
function customize() {
  setopt localoptions err_return

  [[ -d ~/.zutils ]]
  source ~/.zutils/lib/init.zsh
  init::once

  source ~/.zutils/lib/colors.zsh
  source ~/.zutils/lib/file.zsh
  source ~/.zutils/lib/util.zsh

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
  alias la=file::la
  alias ll=file::ll
  alias ls="${aliases[ls]:-ls} --color=tty"
  alias nvim='NVIM=nvim nvim'
  alias pfd='whence -f'
  alias rm=file::rm
  alias ta='util::ta'
  alias tl='tmux list-sessions'
  alias tmux='TERM=screen-256color tmux -2'
  alias ts=util::tmux_start
  alias vi=util::vim                                                            # alias vi='vi -p'
  alias vim=util::vim                                                           # alias vim='vim -p'

  fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions $fpath)

  # case-insensitive (uppercase from lowercase) completion
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  # process completion
  zstyle ':completion:*:processes' command "ps -au$USER"
  zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
  function expand-or-complete-with-dots() {                                     # Displays red dots when autocompleting
    printf "%s......%s" "${COLOR_Red}" "${COLOR_Color_Off}"
    zle expand-or-complete-prefix
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  zle -N down-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey '^[OD' beginning-of-line
  bindkey '^[OC' end-of-line
  bindkey -s 'OM' ''
  # bindkey '^[[3~' delete-char
  # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
  bindkey -r '^S'
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^[[A' up-line-or-beginning-search                                    # Up
  bindkey '^[[B' down-line-or-beginning-search                                  # Down
  bindkey '^I' expand-or-complete-with-dots
  # bindkey '^I' expand-or-complete-prefix

  unalias run-help 2>/dev/null
  autoload run-help
  autoload -Uz up-line-or-beginning-search                                      # Put cursor at end of line when using Up for command history
  autoload -Uz down-line-or-beginning-search                                    # Put cursor at end of line when using Down for command history
  autoload -Uz bashcompinit
  autoload -Uz compinit compdef
  autoload -Uz promptinit

  util::install_precmd
  util::setup_abbrev
  util::start_ssh_agent 'ssh-agent'

  # Local configurations
  if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
  fi

  bashcompinit
  compinit
  promptinit
}
customize
