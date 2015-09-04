# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__COMMON__ || return
__COMMON__="$(base::script_signature ${0:a})"

source ${__MYZSHLIB__}/file.zsh
source ${__MYZSHLIB__}/io.zsh
source ${__MYZSHLIB__}/util.zsh

# [[ -n "$BASH" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${BASH_SOURCE}")
# [[ -n "$ZSH_NAME" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${(%):-%N}")

RETVAL=

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
CONFIG_DIR=$(dirname "$__MYZSHLIB__")
GET_DIRCOLORS=$($DIRCOLORS_CMD "$CONFIG_DIR/third_party/dircolors-solarized/dircolors.256dark")
eval "$GET_DIRCOLORS"
# }}}

# Aliases {{{

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

# Functions {{{
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
      \tmux send-keys -t "$1:$window.$id" C-z
      sleep 0.1
      \tmux send-keys -t "$1:$window.$id" ENTER
      sleep 0.1
      if [[ $cmd != "bash" && $cmd != "zsh" && $cmd != "blaze64" ]]; then
        # run "\\tmux send-keys -t \"$1:$window\" C-z"
        # run "\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        sleep 0.1
        # run "\\tmux send-keys -t \"$1:$window.$id\" fg ENTER"
        \tmux send-keys -t "$1:$window.$id" fg ENTER
      else
        \tmux send-keys -t "$1:$window.$id" source \ $setenv ENTER
        # run "\\tmux send-keys -t \"$1:$window.$id\" source \\ $setenv ENTER"
      fi
    done
  done
  \tmux attach -d -t "$1"
}

function tmux_start() {
  if [[ ! -z "$TMUX" ]]; then
    io::warn "Already in tmux, nothing to be done."
    return
  fi
  \tmux info &> /dev/null
  if [[ $? -eq 1 ]]; then
    io::warn "Starting tmux server..."
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

function histgrep() {
  tac ${HISTFILE:-~/.bash_history} | grep -m 1 "$@"
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
    eval $_cmd_
    set +o noglob
  fi
}
# }}}

# Bootstrap util functions {{{
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

function link_bash() {
  [[ "$#" == 1 ]] || return false
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
  [[ "$#" == 1 ]] || return false
  local _miscfong_="$1"
  _miscfong_="${_miscfong_%/}"

  mkdir -p "$HOME/.config/terminator" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/terminator_config" "$HOME/.config/terminator/config"

  mkdir -p "$HOME/.config/pip" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/pip.conf" "$HOME/.config/pip/pip.conf"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_miscfong_/.inputrc" "$HOME/.inputrc"
  backup_and_link "$_miscfong_/.gitconfig-linux" "$HOME/.gitconfig"
  backup_and_link "$_miscfong_/.gitignore" "$HOME/.gitignore"
  backup_and_link "$_miscfong_/git-new-workdir" "$HOME/.local/bin/git-new-workdir"
  backup_and_link "$_miscfong_/assh.config" "$HOME/.ssh/config.advanced"
}

function link_tmux() {
  [[ "$#" == 1 ]] || return false
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
  [[ "$#" == 1 ]] || return false
  local _utilsconf_="$1"
  _utilsconf_="${_utilsconf_%/}"

  mkdir -p "$HOME/.local/bin" > /dev/null 2>/dev/null
  backup_and_link "$_utilsconf_/bash/winmove.sh" "$HOME/.local/bin/winmove.sh"
  backup_and_link "$_utilsconf_/bash/winresize.sh" "$HOME/.local/bin/winresize.sh"
}

function link_vim() {
  [[ "$#" == 1 ]] || return false
  local _vimconf_="$1"
  _vimconf_="${_vimconf_%/}"

  backup_and_link "$_vimconf_/.gvim.sh" "$HOME/.gvim.sh"
  backup_and_link "$_vimconf_/.gvimrc" "$HOME/.gvimrc"
  backup_and_link "$_vimconf_/.vimrc" "$HOME/.vimrc"
}

function link_zsh() {
  [[ "$#" == 1 ]] || return false
  local _zshconf_="$1"
  _zshconf_="${_zshconf_%/}"

  if [[ ! -d "$HOME/.zprezto" ]]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
  fi

  # if [[ -d "$HOME/.zshcustom" ]]; then
    # echo "$HOME/.zshcustom exists! Nothing done."
    # return
  # fi

  # _zshcustom_="$HOME/.zshcustom"
  # mkdir -p "$_zshcustom_" > /dev/null 2>/dev/null

  backup_and_link "$_zshconf_/.zshrc.common" "$HOME/.zshrc.common"

  # if [[ ! -h "$_zshcustom_/themes" ]]; then
    # ln -s "$_zshconf_/themes" "$_zshcustom_/themes"
  # fi
}

function link_x11() {
  [[ "$#" == 1 ]] || return false
  local _x11conf_="$1"
  _x11conf_="${_x11conf_%/}"

  # backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xinitrc"
  backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xsessionrc"
  backup_and_link "$_x11conf_/.xbindkeysrc" "$HOME/.xbindkeysrc"
}

function link_ctags() {
  [[ "$#" == 1 ]] || return false
  local _ctagsconf_="$1"
  _ctagsconf_="${_ctagsconf_%/}"

  backup_and_link "$_ctagsconf_" "$HOME/.ctagscnf"
}

function link_all() {
  [[ "$#" == 1 ]] || return false
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

util::start_ssh_agent
