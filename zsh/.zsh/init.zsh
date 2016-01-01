# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

# Options are not ordered alphabetically, but their order in zsh man page
# Changing Directories
setopt AUTOCD                                                                   # Switching directories for lazy people
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT

# Completion
setopt ALWAYS_TO_END                                                            # When complete from middle, move cursor
setopt AUTO_LIST
setopt AUTO_MENU                                                                # Automatically use menu completion after the second consecutive request for completion
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt NO_COMPLETE_ALIASES                                                      # Prevent aliases from being internally substituted before completion is attempted
setopt COMPLETE_IN_WORD                                                         # Not just at the end
setopt GLOB_COMPLETE
setopt LIST_AMBIGUOUS
setopt LIST_TYPES
setopt NO_MENU_COMPLETE

# Expansion and Globbing
setopt BAD_PATTERN
setopt CASEMATCH                                                                # Whether the regex comparison (e.g. =~) will match case
setopt EXTENDED_GLOB                                                            # Weird &amp; wacky pattern matching - yay zsh!
setopt GLOB
setopt MARK_DIRS
setopt NO_NOMATCH                                                               # pass through '*' if globbing fails
setopt NO_WARN_CREATE_GLOBAL

# Input/Output
setopt ALIASES
setopt CLOBBER
setopt CORRECT
setopt NO_FLOW_CONTROL
setopt INTERACTIVE_COMMENTS                                                     # Escape commands so I can use them later
setopt PRINT_EXIT_VALUE                                                         # Alert me if something's failed
setopt RC_QUOTES
setopt SHORT_LOOPS

# Job Control
setopt CHECK_JOBS
setopt NOHUP                                                                    # Don't kill background jobs when I logout
setopt LONG_LIST_JOBS
setopt MONITOR

# Prompting
setopt PROMPT_BANG
setopt PROMPT_CR                                                                # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
setopt PROMPT_PERCENT
setopt PROMPT_SUBST

# Scripts and Functions
setopt C_BASES
setopt NO_ERR_RETURN                                                            # Enable this would break completion!
setopt FUNCTION_ARGZERO
setopt NO_SOURCE_TRACE
setopt NO_XTRACE

# Shell Emulation
setopt NO_CONTINUE_ON_ERROR
# setopt KSH_ARRAYS                                                               # Make array index starts at 0
setopt RC_EXPAND_PARAM

# Zle
setopt VI                                                                       # Use vi key bindings in ZSH (bindkey -v)

autoload -Uz -- ~/.zsh/lib/[^_]*(:t)
zstyle ":registry:var:tmux-vars" registry \
  "SSH_CLIENT" "SSH_OS" "SSH_AUTH_SOCK" \
  "DISPLAY" "SSH_AGENT_PID" "P4DIFF"

colors::define
colors::manpage

if (( ${+commands[grc]} )); then
  alias colorify='command grc -es --colour=auto'
  alias ps='colorify ps'
  alias netstat='colorify netstat'
  alias ping='colorify ping'
  alias tail='colorify tail'
  alias head='colorify head'
  alias df='colorify df'
fi

alias aga='ag --hidden'
alias cdlink='file::cdlink'
alias cdr='cd-gitroot'
alias gfind='file::find-ignore-dir ".git"'
alias grepc='command grep -C 5 '
alias gyank='util::yank'
alias gvim='util::gvim'
alias info='command info --vi-keys'
alias l='file::ls'
alias la='file::ls -a'
alias lad='file::ld -a'
alias laf='file::lf -a'
alias lal='file::ll -a'
alias ldir='file::ld'
alias lf='file::lf'
alias ll='file::ls -l'
alias lla='file::ls -la'
alias llad='file::ld -la'
alias llaf='file::lf -la'
alias llal='file::ll -la'
alias lld='file::ld -l'
alias llf='file::lf -l'
alias llink='file::ll'
alias lll='file::ll -l'
alias mank='command man -K'
alias nvim='NVIM=nvim nvim'
alias run='zsh::run'
alias ssh='net::ssh'
alias stow='command stow -v'
alias ta='tmux::attach -d -t'
alias tl='command tmux list-sessions'
alias tmux='TERM=screen-256color command tmux -2'
alias ts='\tmux start-server; \tmux attach'
alias vartype='declare -p'
alias vi='util::vim'                                                            # alias vi='vi -p'
alias vim='util::vim'                                                           # alias vim='vim -p'
alias zunbindkey='bindkey -r'
[[ -n ${aliases[run-help]+1} ]] && unalias run-help                             # Use built-in run-help for online help
autoload run-help                                                               # Unset previous run-help alias

zle -N up-line-or-beginning-search
autoload -Uz up-line-or-beginning-search                                        # Put cursor at end of line when using Up for command history
zle -N down-line-or-beginning-search
autoload -Uz down-line-or-beginning-search                                      # Put cursor at end of line when using Down for command history

# TODO(me): Bind C-Left and C-Right as HOME / END
# '^L' is captured by tmux for navigating between tmux panes
# bindkey '^[OD' beginning-of-line                                              # Set left arrow as HOME
# bindkey '^[OC' end-of-line                                                    # Set right arrow as END
bindkey "[1;5D" beginning-of-line                                             # Set ctrl + left arrow as HOME
bindkey "[1;5C" end-of-line                                                   # Set ctrl + right arrow as END
bindkey -s 'OM' ''                                                          # Let enter in numeric keypad work as newline (return)
bindkey -r '^S'                                                                 # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
# bindkey '^R' history-incremental-pattern-search-backward                      # Search history backward incrementally
# bindkey '\C-R' history-incremental-pattern-search-backward                    # Search history backward incrementally
# bindkey 'r' history-incremental-pattern-search-backward                     # Search history backward incrementally
# bindkey -s 'd' ''
# bindkey -s 'z' ''
# bindkey -s 'c' ''
bindkey '^[[A' up-line-or-beginning-search                                      # Up
bindkey '^[[B' down-line-or-beginning-search                                    # Down
# bindkey '^I' expand-or-complete-prefix
# bindkey '^[[3~' delete-char
bindkey '\C-n' menu-complete
bindkey '\C-p' reverse-menu-complete

# zsh::setup-abbrevs

autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd tmux::copy-vars
if [[ -z ${PROFILING+1} ]]; then
  add-zsh-hook -Uz zshexit tmux::try-switch
  # trap 'tmux::try-switch' EXIT
  if zstyle -t ":registry:var:tty" registry 'virtual'; then
    prompt powerline-shell
    # powerline-plus is the native powerline bindings from powerline
    # powerline is the built-in powerline theme from prezto
    # prompt powerline-plus
  else
    prompt clint
  fi
fi
