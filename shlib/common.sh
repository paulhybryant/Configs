# vim: set sw=2 ts=2 sts=2 et tw=78 foldlevel=0 foldmethod=marker filetype=sh nospell:

# This depends on the homebrew package coreutils, which provides the gnu
# coreutils. All commands provided have a prefix 'g'. E.g. ls -> gls
# TODO: Test existence of homebrew if it is a Mac
[[ "$OSTYPE" == "darwin"* ]] && CMDPREFIX="g"

# Platform specific settings
function config_darwin() {
  export BREWHOME=$HOME/.homebrew
  export PATH=$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$PATH
  alias updatedb="/usr/libexec/locate.updatedb"
  if ${CMDPREFIX}ls --color -d . &>/dev/null 2>&1
  then
    alias ls="${CMDPREFIX}ls"
  else
    alias ls="ls -G"
  fi
}

function config_linux() {
  export BREWHOME=$HOME/.linuxbrew
  export PATH=$HOME/.local/bin:$BREWHOME/bin:$BREWHOME/sbin:$PATH
}


[[ "$OSTYPE" == "darwin"* ]] && config_darwin
[[ "$OSTYPE" == "linux-gnu"* ]] && config_linux

export MANPATH="$BREWHOME/share/man:$MANPATH"
export INFOPATH="$BREWHOME/share/info:$INFOPATH"
export XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog"

# Inclusion guard {{{
[[ -n "$BASH" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${BASH_SOURCE}")
[[ -n "$ZSH_NAME" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${(%):-%N}")

# [[ "$OSTYPE" != "darwin"* ]] && __LIB_COMMON_NEW_VERSION__=$(date -r "$__LIB_COMMON__" +%s)
# [[ "$OSTYPE" == "darwin"* ]] && __LIB_COMMON_NEW_VERSION__=$(stat -f '%m' "$__LIB_COMMON__")
__LIB_COMMON_NEW_VERSION__=$(${CMDPREFIX}date -r "$__LIB_COMMON__" +%s)
[[ -n "$__LIB_COMMON_VERSION__" && "$__LIB_COMMON_VERSION__" -eq "$__LIB_COMMON_NEW_VERSION__" ]] && return

__LIB_COMMON_VERSION__="$__LIB_COMMON_NEW_VERSION__"

if [[ $DEBUG == true ]]; then
  # [[ "$OSTYPE" != "darwin"* ]] && echo "$__LIB_COMMON__ sourced, modified at $(date --date=@$__LIB_COMMON_NEW_VERSION__)"
  # [[ "$OSTYPE" == "darwin"* ]] && echo "$__LIB_COMMON__ sourced, modified at $(date -r $__LIB_COMMON_NEW_VERSION__)"
  echo "$__LIB_COMMON__ sourced, modified at $(${CMDPREFIX}date --date=@$__LIB_COMMON_NEW_VERSION__)"
fi
RETVAL=
REPLY=
# }}}

# Environment {{{
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

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# HISTSIZE=50000
# HISTFILESIZE=20000

# Allow pass Ctrl + C(Q) for terminator
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

# Force control sequences such as <c-s> and <c-q> to vim
stty -ixon > /dev/null 2>/dev/null

DIRCOLORS_CMD="${CMDPREFIX}dircolors"
CONFIG_DIR=$(dirname "$__LIB_COMMON__")
CONFIG_DIR=$(dirname "$CONFIG_DIR")
GET_DIRCOLORS=$($DIRCOLORS_CMD "$CONFIG_DIR/third_party/dircolors-solarized/dircolors.256dark")
eval "$GET_DIRCOLORS"
# }}}

# aliases {{{

# vi
# alias vi="vi -p"
# alias vim="vim -p"

# tmux
alias tmux="TERM=screen-256color tmux -2"

# Use vimpager to replace less, which is used to view man page
# export PAGER=/usr/local/bin/vimpager
# alias less=$PAGER
# alias zless=$PAGER

# misc
# Print function definition
alias pfd="declare -f"
alias rm="rm -v"
alias nvim="NVIM=nvim nvim"
# Usage:
#   is_port_open 127.0.0.1 80
#   is_port_open 127.0.0.1 80 90
#   is_port_open 127.0.0.1 80-90
alias is_port_open="nc -zv "
alias tl='tmux list-sessions'
alias ts='tmux_start'
alias grepc='grep -C 5 '
alias ls="${aliases[ls]:-ls} --color=tty"

# }}}

# functions library {{{

function ta() {
  local setenv=$(mktemp)
  : > "$setenv"
  for var in SSH_OS SSH_CLIENT DISPLAY;
  do
    local value=
    eval value=\$$var
    # local _var_
    # eval "_val_=\"\${$var}\""
    # echo $_val_
    \tmux set-environment -t "$1" $var "$value"
    echo "export $var=\"$value\"" >> "$setenv"
  done
  for window in $(\tmux list-windows -t "$1" -F "#W");
  do
    for pane_id_command in $(\tmux list-panes -t "$1:$window" -F "#P:#{pane_current_command}");
    do
      local id=${pane_id_command%%:*}
      local cmd=${pane_id_command##*:}
      if [[ $cmd != "bash" && $cmd != "zsh" && $cmd != "blaze64" ]]; then
        # run "\\tmux send-keys -t \"$1:$window\" C-z"
        \tmux send-keys -t "$1:$window" C-z
        sleep 0.2
        # run "\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        sleep 0.2
        # run "\\tmux send-keys -t \"$1:$window.$id\" fg ENTER"
        \tmux send-keys -t "$1:$window.$id" fg ENTER
      else
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        # run "\\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
      fi
    done
  done
  \tmux attach -t "$1"
}

function tmux_start() {
  if [[ ! -z "$TMUX" ]]; then
    echo "Already in tmux, nothing to be done."
    return
  fi
  \tmux info &> /dev/null
  if [[ $? -eq 1 ]]; then
    echo "Starting tmux server..."
    touch "$HOME/.tmux_restore"
    \tmux start-server
    \rm "$HOME/.tmux_restore"
  fi
  if [[ "$#" == 0 ]]; then
    \tmux attach
  else
    \tmux "$@"
  fi
}

function find_no_git() {
  find . -wholename "*/.git" -prune -o -wholename "./third_party" -prune -o "$@" -print
  # Commands with the same output
  # find . -wholename "./.git" -prune -o -wholename "./third_party" -prune -o -type f -print
  # find . -type f ! -path "./.git/*" ! -path "./third_party/*" -print
  # find . -type d \( -path './third_party*' -o -path './.git*' \) -prune -o -type f -print
  # Differences betwee these commands
  # 1. -prune stops find from descending into a directory. Just specifying
  #    -not -path will still descend into the skipped directory, but -not -path
  #    will be false whenever find tests each file.
  # 2. find prints the pruned directory
  # So performance of 1 and 3 will be better
}

function colorful_manpage() {
  # The following won't have effect unless less is used (instead of vimpager)
  # http://superuser.com/questions/452034/bash-colorized-man-page
  #
  #   L E S S   C O L O R S   F O R   M A N   P A G E S
  #

  # CHANGE FIRST NUMBER PAIR FOR COMMAND AND FLAG COLOR
  # currently 0;33 a.k.a. brown, which is dark yellow for me
    export LESS_TERMCAP_md=$'\E[0;33;5;74m'  # begin bold

  # CHANGE FIRST NUMBER PAIR FOR PARAMETER COLOR
  # currently 0;36 a.k.a. cyan
    export LESS_TERMCAP_us=$'\E[0;36;5;146m' # begin underline

  # don't change anything here
    export LESS_TERMCAP_mb=$'\E[1;31m'       # begin blinking
    export LESS_TERMCAP_me=$'\E[0m'           # end mode
    export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'           # end underline

  #########################################
  # Colorcodes:
  # Black       0;30     Dark Gray     1;30
  # Red         0;31     Light Red     1;31
  # Green       0;32     Light Green   1;32
  # Brown       0;33     Yellow        1;33
  # Blue        0;34     Light Blue    1;34
  # Purple      0;35     Light Purple  1;35
  # Cyan        0;36     Light Cyan    1;36
  # Light Gray  0;37     White         1;37
  #########################################
}

function start_ssh_agent() {
  # Start ssh agent if needed
  # Check to see if SSH Agent is already running
  agent_pid="$(ps -ef | grep "ssh-agent" | grep -v "grep" | awk '{print($2)}')"

  # If the agent is not running (pid is zero length string)
  if [[ -z "$agent_pid" ]]; then
      # Start up SSH Agent

      # this seems to be the proper method as opposed to `exec ssh-agent bash`
      eval "$(ssh-agent)"
  fi
}

function gnome-shell-exts() {
  grep "name\":" ~/.local/share/gnome-shell/extensions/*/metadata.json /usr/share/gnome-shell/extensions/*/metadata.json | awk -F '"name": "|",' '{print $2}'
}

function ll() {
  ls -lh "$@"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      for(i = 5; y < 1; i--)
        y = sum / (2^(10*i))
      printf("Total (files only) %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< "$(ls -l $@)"
}

function la() {
  ls -alF "$@"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      for(i = 5; y < 1; i--)
        y = sum / (2^(10*i))
      printf("Total (files only) %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< "$(ls -laF $@)"
}

function myssh() {
  ssh -Y "$@" -t "export SSH_OS=\"`uname`\"; zsh"
}

function histgrep() {
  tac ${HISTFILE:-~/.bash_history} | grep -m 1 "$@"
}

function backup_and_link() {
  local _src_=$1
  local _target_=$2

  if [[ -h "$_target_" ]]; then
    rm "$_target_"
  elif [[ -f "$_target_" ]]; then
    echo "Please rename or backup $_target_."
    return
  fi

  if [[ -d "$_target_" ]]; then
    echo "Directory $_target_ already exists."
    return
  fi
  ln -s "$_src_" "$_target_"
}

function current_script_path() {
  local _dir_=$1
  local  _resultvar_=$2
  local _dirname_=$(dirname "$_dir_")
  local _result_=$(realpath "$_dirname_")
  if [[ -z "$_resultvar_" ]]; then
    echo "$_result_"
  else
    eval "$_resultvar_='$_result_'"
  fi
}

function strip_slash_if_exist() {
  [[ $1 =~ .*/$ ]] && RETVAL=${1%/}
  echo "$RETVAL"
}

function run() {
  local _cmd_="$1"
  local _msg_="$2"
  [[ $VERBOSE == true ]] && echo "$_msg_"
  if [[ $DRYRUN == true ]]; then
    echo "$_cmd_"
  else
    if [[ $LOGCMD == true && -n "$LOGCMDFILE" ]]; then
      local _ts_=$(date "+%Y-%m-%d %T:")
      echo "$_ts_ $_cmd_" >> $LOGCMDFILE
    fi
    set -o noglob
    $_cmd_
    set +o noglob
  fi
}

function exit_if_not_exist() {
  which "$1" > /dev/null
  if [[ $? -ne 0 ]]; then
    echo "$1 not installed." >&2
    exit 1
  fi
}

function confirm() {
  local _question_="$1"
  if [[ $CONFIRM == true ]]; then
    read -p "$_question_"
  else
    REPLY="y"
  fi
}

function escape() {
  RETVAL=$(printf %q "$1")
}

function git_branch_exist() {
  local _branch_="$1"
  if [[ -n $(git branch --list "$_branch_") ]];
  then
    RETVAL=1
  else
    RETVAL=0
  fi
}

# }}}

# Bootstrap util functions {{{

function link_bash() {
  [[ "$#" == 1 ]] || return 1
  local _bashconf_="$1"
  _bashconf_="${_bashconf_%/}"

  [[ -z "$__BASH_CUSTOM__" ]] && echo "source $HOME/.bashrc.custom" >> "$HOME/.bashrc"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ ! -f "$HOME/.bash_profile" ]]; then
      echo "if [[ -f \"$HOME/.bashrc\" ]]; then source \"$HOME/.bashrc;\" fi" > "$HOME/.bash_profile"
    fi
  fi

  backup_and_link "$_bashconf_/.bashrc.custom" "$HOME/.bashrc.custom"
}

function link_misc() {
  [[ "$#" == 1 ]] || return 1
  local _miscfong_="$1"
  _miscfong_="${_miscfong_%/}"

  backup_and_link "$_miscfong_/../notes" "$HOME/Notes"

  mkdir -p "$HOME/.config/terminator" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/terminator_config" "$HOME/.config/terminator/config"

  mkdir -p "$HOME/.config/pip" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/pip.conf" "$HOME/.config/pip/pip.conf"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/.inputrc" "$HOME/.inputrc"
  backup_and_link "$_miscfong_/.gitconfig-linux" "$HOME/.gitconfig"
  backup_and_link "$_miscfong_/.gitignore" "$HOME/.gitignore"
  backup_and_link "$_miscfong_/git-new-workdir" "$HOME/.local/bin/git-new-workdir"
}

function link_tmux() {
  [[ "$#" == 1 ]] || return 1
  local _tmuxconf_="$1"
  _tmuxconf_="${_tmuxconf_%/}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.linux" "$HOME/.tmux.conf.local"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.mac" "$HOME/.tmux.conf.local"
  fi

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_tmuxconf_/.tmux-default.conf" "$HOME/.tmux-default.conf"
  backup_and_link "$_tmuxconf_/.tmux.conf" "$HOME/.tmux.conf"
  backup_and_link "$_tmuxconf_/.tmux.extra.conf" "$HOME/.tmux.extra.conf"
  backup_and_link "$_tmuxconf_/muxcfg" "$HOME/.local/bin/muxcfg"

  mkdir -p "$HOME/.tmuxinator" > /dev/null 2>/dev/null
  backup_and_link "$_tmuxconf_/project.yml.template" "$HOME/.tmuxinator/project.yml.template"

  mkdir -p "$HOME/.tmux"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function link_utils() {
  [[ "$#" == 1 ]] || return 1
  local _utilsconf_="$1"
  _utilsconf_="${_utilsconf_%/}"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_utilsconf_/bash/winmove.sh" "$HOME/.local/bin/winmove.sh"
  backup_and_link "$_utilsconf_/bash/winresize.sh" "$HOME/.local/bin/winresize.sh"
}

function link_vim() {
  [[ "$#" == 1 ]] || return 1
  local _vimconf_="$1"
  _vimconf_="${_vimconf_%/}"

  backup_and_link "$_vimconf_/.gvim.sh" "$HOME/.gvim.sh"
  backup_and_link "$_vimconf_/.gvimrc" "$HOME/.gvimrc"
  backup_and_link "$_vimconf_/.vimrc" "$HOME/.vimrc"
}

function link_zsh() {
  [[ "$#" == 1 ]] || return 1
  local _zshconf_="$1"
  _zshconf_="${_zshconf_%/}"

  if [[ ! -d "$HOME/.zprezto" ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
    cat << EOF >> $HOME/.zshrc
if [[ -e "$HOME/.zshrc.custom" ]]; then
  source ~/.zshrc.custom
fi
EOF
  fi

  # if [[ -d "$HOME/.zshcustom" ]]; then
    # echo "$HOME/.zshcustom exists! Nothing done."
    # return
  # fi

  # _zshcustom_="$HOME/.zshcustom"
  # mkdir -p "$_zshcustom_" > /dev/null 2>/dev/null

  backup_and_link "$_zshconf_/.zshrc.zprezto" "$HOME/.zshrc"
  backup_and_link "$_zshconf_/zsh.custom" "$HOME/.zshrc.custom"

  # if [[ ! -h "$_zshcustom_/themes" ]]; then
    # ln -s "$_zshconf_/themes" "$_zshcustom_/themes"
  # fi
}

function link_x11() {
  [[ "$#" == 1 ]] || return 1
  local _x11conf_="$1"
  _x11conf_="${_x11conf_%/}"

  # backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xinitrc"
  backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xsessionrc"
  backup_and_link "$_x11conf_/.xbindkeysrc" "$HOME/.xbindkeysrc"
}

function link_ctags() {
  [[ "$#" == 1 ]] || return 1
  local _ctagsconf_="$1"
  _ctagsconf_="${_ctagsconf_%/}"

  backup_and_link "$_ctagsconf_" "$HOME/.ctagscnf"
}

function link_all() {
  [[ "$#" == 1 ]] || return 1
  local _scriptpath_="$1"
  link_misc "$_scriptpath_/misc"
  link_tmux "$_scriptpath_/tmux"
  link_vim "$_scriptpath_/vim"
  link_bash "$_scriptpath_/bash"
  link_utils "$_scriptpath_/utils"
  link_zsh "$_scriptpath_/zsh"
  link_x11 "$_scriptpath_/x11"
  link_ctags "$_scriptpath_/ctags"
}


# }}}

############ Start of wrap_alias ############ {{{
# wrap_alias takes three arguments:
# $1: The name of the alias
# $2: The command used in the alias
# $3: The arguments in the alias all in one string
# Generate a wrapper completion function (completer) for an alias
# based on the command and the given arguments, if there is a
# completer for the command, and set the wrapper as the completer for
# the alias.
function wrap_alias() {
  [[ "$#" == 3 ]] || return 1

  local alias_name="$1"
  local aliased_command="$2"
  local alias_arguments="$3"
  local num_alias_arguments=$(echo "$alias_arguments" | wc -w)

  # The completion currently being used for the aliased command.
  local completion=$(complete -p "$aliased_command" 2> /dev/null)

  # Only a completer based on a function can be wrapped so look for -F
  # in the current completion. This check will also catch commands
  # with no completer for which $completion will be empty.
  echo "$completion" | grep -q -- -F || return 0

  local namespace=alias_completion::

  # Extract the name of the completion function from a string that
  # looks like: something -F function_name something
  # First strip the beginning of the string up to the function name by
  # removing "* -F " from the front.
  local completion_function=${completion##* -F }
  # Then strip " *" from the end, leaving only the function name.
  completion_function=${completion_function%% *}

  # Try to prevent an infinite loop by not wrapping a function
  # generated by this function. This can happen when the user runs
  # this twice for an alias like ls='ls --color=auto' or alias l='ls'
  # and alias ls='l foo'
  [[ "${completion_function#$namespace}" != $completion_function ]] && return 0

  local wrapper_name="${namespace}${alias_name}"

  eval "
function ${wrapper_name}() {
  let COMP_CWORD+=$num_alias_arguments
  args=( \"${alias_arguments}\" )
  COMP_WORDS=( $aliased_command \${args[@]} \${COMP_WORDS[@]:1} )
  $completion_function
  }
"

  # To create the new completion we use the old one with two
  # replacements:
  # 1) Replace the function with the wrapper.
  local new_completion=${completion/-F * /-F $wrapper_name }
  # 2) Replace the command being completed with the alias.
  new_completion="${new_completion% *} $alias_name"

  eval "$new_completion"
}
############ End of wrap_alias ############ }}}

start_ssh_agent
colorful_manpage

# RVM
if [ -f ~/.rvm/scripts/rvm ]; then
  source ~/.rvm/scripts/rvm
fi
