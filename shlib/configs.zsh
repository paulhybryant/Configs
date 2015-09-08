# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: configs.zsh -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

source "${0:h}/init.zsh"
source "${0:h}/file.zsh"
source "${0:h}/os.zsh"
source "${0:h}/io.zsh"
source "${0:h}/util.zsh"
# [[ -n "$BASH" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${BASH_SOURCE}")
# [[ -n "$ZSH_NAME" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${(%):-%N}")

function configs::_config_darwin() {
  export BREWVERSION="homebrew"
  export BREWHOME="$HOME/.$BREWVERSION"
  alias updatedb="/usr/libexec/locate.updatedb"
  export CMDPREFIX="g"
  alias ls="${CMDPREFIX}ls"
  alias mktemp="${CMDPREFIX}mktemp"
  alias stat="${CMDPREFIX}stat"
  alias date="${CMDPREFIX}date"
}
function configs::_config_linux() {
  export BREWVERSION="linuxbrew"
  export BREWHOME="$HOME/.$BREWVERSION"
}
function configs::_config_brew() {
  export PATH=$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$PATH
  export MANPATH="$BREWHOME/share/man:${__MYCONFIGS__}/shlib/man:$MANPATH"
  export INFOPATH="$BREWHOME/share/info:$INFOPATH"
  export XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"
  unalias run-help 2>/dev/null
  autoload run-help
  export HELPDIR=$BREWHOME/share/zsh/help
}
function configs::bootstrap() {
  if os::OSX; then
    configs::_config_darwin
  elif os::LINUX; then
    configs::_config_linux
  fi
  configs::_config_brew
}
function configs::_config_env() {
  export EDITOR='vim'
  export GREP_OPTIONS='--color=auto'
  # Don't enable the following line, it will screw up HOME and END key in tmux
  # export TERM=xterm-256color
  # If it is really need for program foo, create an alias like this
  # alias foo='TERM=xterm-256color foo'
  export TERM=screen-256color
  export VISUAL='vim'
  export XDG_CACHE_HOME=$HOME/.cache
  export XDG_CONFIG_HOME=$HOME/.config
  export XDG_DATA_HOME=$HOME/.local/share

  # Setup directory colors
  GET_DIRCOLORS=$(${CMDPREFIX}dircolors "${__MYCONFIGS__}/third_party/dircolors-solarized/dircolors.256dark")
  eval "$GET_DIRCOLORS"

  # Don't put duplicate lines or lines starting with space in the history.
  # See bash(1) for more options
  HISTCONTROL=ignoreboth:erasedups
  # For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
  export HISTSIZE=50000
  export SAVEHIST=$HISTSIZE
  if [ -z "$HISTFILE" ]; then
    export HISTFILE=$HOME/.zsh_history
  fi
  # Show history
  case $HIST_STAMPS in
    "mm/dd/yyyy") alias history='fc -fl 1' ;;
    "dd.mm.yyyy") alias history='fc -El 1' ;;
    "yyyy-mm-dd") alias history='fc -il 1' ;;
    *) alias history='fc -l 1' ;;
  esac

  # Allow pass Ctrl + C(Q, S) for terminator
  stty ixany
  stty ixoff -ixon
  stty stop undef
  stty start undef

  # Setup powerline for zsh prompt {{{
  function powerline_precmd() {
    export PS1="$(powerline-shell.py --colorize-hostname $? --shell zsh 2> /dev/null)"
  }

  function install_powerline_precmd() {
    for s in "${precmd_functions[@]}"; do
      if [ "$s" = "powerline_precmd" ]; then
        return
      fi
    done
    precmd_functions+=(powerline_precmd)
  }
  install_powerline_precmd
  # }}}
  # zsh options {{{
  # setopt aliases
  # setopt auto_list
  setopt vi                                                                     # Use vi key bindings in ZSH
  setopt append_history
  # setopt correct
  # setopt correctall
  setopt extended_history
  setopt hist_expire_dups_first
  setopt hist_ignore_dups                                                       # ignore duplication command history list
  setopt hist_ignore_space
  setopt hist_no_store
  setopt hist_save_no_dups
  setopt hist_verify
  setopt inc_append_history
  setopt share_history                                                          # share command history data
  setopt CLOBBER
  setopt always_to_end                                                          # When complete from middle, move cursor
  setopt auto_cd                                                                # Switching directories for lazy people
  setopt automenu                                                               # Automatically use menu completion after the second consecutive request for completion
  setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups           # See: http://zsh.sourceforge.net/Intro/intro_6.html
  setopt nohup                                                                  # Don't kill background jobs when I logout
  setopt complete_in_word                                                       # Not just at the end
  setopt extended_glob                                                          # Weird &amp; wacky pattern matching - yay zsh!
  setopt hist_verify                                                            # When using ! cmds, confirm first
  setopt histreduceblanks                                                       # Remove superfluous blanks from each command line being added to the history list
  setopt histignorespace                                                        # Remove command lines from the history list when the first character on the line is a space, or when one of the expanded aliases contains a leading space
  setopt histignorealldups                                                      # Do not enter command lines into the history list if they are duplicates of the previous event
  setopt interactive_comments                                                   # Escape commands so I can use them later
  setopt interactivecomments
  setopt no_prompt_cr                                                           # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
  setopt nonomatch                                                              # pass through '*' if globbing fails
  setopt print_exit_value                                                       # Alert me if something's failed
  setopt pushd_ignore_dups
  # Do not complete alias before completion is finished
  # This would allow completion to work for aliases
  # e.g. alias tmux=tmux -2
  # However, it would prevent the completion for aliases for subcommands.
  # e.g. without this set, bb can be completed as blaze build, because bb is
  # expanded to blaze build before completion. With this set, bb will not be
  # expanded and there will be no completion for that.
  # setopt complete_aliases
  # unsetopt correct                                                            # Disable autocorrect guesses.
  # unsetopt CORRECT
  # }}}
  # zstyle {{{
  # case-insensitive (uppercase from lowercase) completion
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  # process completion
  zstyle ':completion:*:processes' command "ps -au$USER"
  zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
  # }}}
  # zle {{{
  function expand-or-complete-with-dots() {                                     # Displays red dots when autocompleting
    echo -n "\e[31m......\e[0m"                                                 # A command with the tab key
    zle expand-or-complete-prefix
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  zle -N down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  # }}}
  # bindkey {{{
  bindkey "^[OD" beginning-of-line
  bindkey "^[OC" end-of-line
  bindkey -s "OM" ""
  # bindkey "^[[3~" delete-char
  # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
  bindkey -r "^S"
  bindkey "^R" history-incremental-pattern-search-backward
  bindkey "^[[A" up-line-or-beginning-search                                    # Up
  bindkey "^[[B" down-line-or-beginning-search                                  # Down
  bindkey "^I" expand-or-complete-with-dots
  # bindkey "^I" expand-or-complete-prefix
  # }}}
  # autoload {{{
  autoload -Uz bashcompinit
  autoload -Uz compinit compdef
  autoload -Uz down-line-or-beginning-search
  autoload -Uz promptinit
  autoload -Uz up-line-or-beginning-search                                      # Put cursor at end of line when using Up/Down for command history
  # }}}
  fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions $fpath)
}
function configs::_config_alias() {
  # alias vi="vi -p"
  # alias vim="vim -p"
  alias tmux="TERM=screen-256color tmux -2"
  # Use vimpager to replace less, which is used to view man page
  # export PAGER=vimpager
  # alias less=$PAGER
  # alias zless=$PAGER
  alias pfd="whence -f"
  alias rm=file::rm
  alias nvim="NVIM=nvim nvim"
  alias tl='tmux list-sessions'
  alias ts=util::tmux_start
  alias ta=util::ta
  alias grepc='grep -C 5 '
  alias ls="${aliases[ls]:-ls} --color=tty"
  alias ll=file::ll
  alias la=file::la
}
function configs::config() {
  configs::_config_env
  configs::_config_alias
  util::start_ssh_agent
}
function configs::end() {
  bashcompinit
  compinit
  promptinit
}

: <<=cut
=back
=cut
