# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${0:h}/init.zsh
source ${0:h}/file.zsh
source ${0:h}/os.zsh
source ${0:h}/io.zsh
source ${0:h}/util.zsh
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
  export MANPATH="$BREWHOME/share/man:$MANPATH"
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
  # Turn on vi mode by default.
  set -o vi

  # Don't enable the following line, it will screw up HOME and END key in tmux
  # If it is really need for program foo, create an alias like this
  # alias foo='TERM=xterm-256color foo'
  export TERM=screen-256color
  export VISUAL='vim'
  export EDITOR='$VISUAL'
  export GREP_OPTIONS='--color=auto'
  export XDG_CACHE_HOME=$HOME/.cache
  export XDG_CONFIG_HOME=$HOME/.config
  export XDG_DATA_HOME=$HOME/.local/share

  # Allow pass Ctrl + C(Q, S) for terminator
  stty ixany
  stty ixoff -ixon
  stty stop undef
  stty start undef

  # Setup directory colors
  GET_DIRCOLORS=$(${CMDPREFIX}dircolors "${__MYCONFIGS__}/third_party/dircolors-solarized/dircolors.256dark")
  eval "$GET_DIRCOLORS"

  # Command history {{{
  # don't put duplicate lines or lines starting with space in the history.
  # See bash(1) for more options
  HISTCONTROL=ignoreboth:erasedups

  if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
  fi

  # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
  HISTSIZE=50000
  SAVEHIST=10000

  # Show history
  case $HIST_STAMPS in
    "mm/dd/yyyy") alias history='fc -fl 1' ;;
    "dd.mm.yyyy") alias history='fc -El 1' ;;
    "yyyy-mm-dd") alias history='fc -il 1' ;;
    *) alias history='fc -l 1' ;;
  esac

  setopt append_history
  setopt extended_history
  setopt hist_expire_dups_first
  setopt hist_ignore_dups                                                         # ignore duplication command history list
  setopt hist_ignore_space
  setopt hist_no_store
  setopt hist_save_no_dups
  setopt hist_verify
  setopt inc_append_history
  setopt share_history                                                            # share command history data

  autoload -Uz down-line-or-beginning-search
  autoload -Uz up-line-or-beginning-search                                        # Put cursor at end of line when using Up/Down for command history
  bindkey "^R" history-incremental-pattern-search-backward
  bindkey "^[[A" up-line-or-beginning-search                                      # Up
  bindkey "^[[B" down-line-or-beginning-search                                    # Down
  zle -N down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  # }}}

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

  setopt auto_cd
  setopt auto_pushd
  setopt pushd_ignore_dups
  setopt nonomatch                                                                # pass through '*' if globbing fails
  # setopt always_to_end
  # setopt auto_list
  # Do not complete alias before completion is finished
  # This would allow completion to work for aliases
  # e.g. alias tmux=tmux -2
  # However, it would prevent the completion for aliases for subcommands.
  # e.g. without this set, bb can be completed as blaze build, because bb is
  # expanded to blaze build before completion. With this set, bb will not be
  # expanded and there will be no completion for that.
  # setopt complete_aliases
  # Default on, resulting in a carriage return ^M when enter on the numeric pad is pressed.
  setopt no_prompt_cr
  # unsetopt aliases
  unsetopt CORRECT                                                                # Disable autocorrect guesses.
  setopt CLOBBER
  setopt extended_glob
  setopt interactivecomments
  bindkey "^[OD" beginning-of-line
  bindkey "^[OC" end-of-line
  bindkey -s "OM" ""
  # bindkey "^[[3~" delete-char
  # By default <C-S> is bind to self-insert, which presents vim from getting the combination.
  bindkey -r "^S"

  function expand-or-complete-with-dots() {                                       # Displays red dots when autocompleting
    echo -n "\e[31m......\e[0m"                                                   # A command with the tab key
    zle expand-or-complete-prefix
    zle redisplay
  }

  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
  # bindkey "^I" expand-or-complete-prefix

  fpath=($BREWHOME/share/zsh-completions $BREWHOME/share/zsh/site-functions $fpath)
}
function configs::_config_alias() {
  # vi
  # alias vi="vi -p"
  # alias vim="vim -p"

  # tmux
  alias tmux="TERM=screen-256color tmux -2"

  # Use vimpager to replace less, which is used to view man page
  # export PAGER=vimpager
  # alias less=$PAGER
  # alias zless=$PAGER

  # misc
  # Print function definition
  alias pfd="declare -f"
  alias rm="rm -v"
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
  autoload -Uz bashcompinit
  bashcompinit
  autoload -Uz compinit
  compinit
}
