[[ -n "$BASH" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${BASH_SOURCE}")
[[ -n "$ZSH_NAME" && -z "$__LIB_COMMON__" ]] && readonly __LIB_COMMON__=$(realpath "${(%):-%N}")

[[ "$OSTYPE" != "darwin"* ]] && __LIB_COMMON_NEW_VERSION__=$(date -r "$__LIB_COMMON__" +%s)
[[ "$OSTYPE" == "darwin"* ]] && __LIB_COMMON_NEW_VERSION__=$(stat -f '%m' "$__LIB_COMMON__")
[[ -n "$__LIB_COMMON_VERSION__" && "$__LIB_COMMON_VERSION__" -eq "$__LIB_COMMON_NEW_VERSION__" ]] && return

__LIB_COMMON_VERSION__="$__LIB_COMMON_NEW_VERSION__"
[[ "$OSTYPE" != "darwin"* ]] && echo "$__LIB_COMMON__ sourced, modified at $(date --date=@$__LIB_COMMON_NEW_VERSION__)"
[[ "$OSTYPE" == "darwin"* ]] && echo "$__LIB_COMMON__ sourced, modified at $(date -r $__LIB_COMMON_NEW_VERSION__)"
RETVAL=
REPLY=

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
    $_cmd_
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

function link_bash() {
  local _bashconf_="${1:-$HOME/Configs/bash}"
  _bashconf_="${_bashconf_%/}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_bashconf_/.bashrc.linux-gnu" "$HOME/.bashrc.platform"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if [[ ! -f "$HOME/.bash_profile" ]]; then
      echo "if [[ -f \"$HOME/.bashrc\" ]]; then source \"$HOME/.bashrc;\" fi" > "$HOME/.bash_profile"
    fi
    backup_and_link "$_bashconf_/.bashrc.mac" "$HOME/.bashrc.platform"
  fi

  backup_and_link "$_bashconf_/.bashrc.custom" "$HOME/.bashrc.custom"

  if [[ -f "$HOME/.google" ]]; then
    backup_and_link "$_bashconf_/.bashrc.google" "$HOME/.bashrc.local"
  elif [[ -f "$HOME/.glaptop" ]]; then
    backup_and_link "$_bashconf_/.bashrc.glaptop" "$HOME/.bashrc.local"
  else
    backup_and_link "$_bashconf_/.bashrc.personal" "$HOME/.bashrc.local"
  fi

  if [[ -f "$HOME/.bashrc" ]]; then
    echo "source $HOME/.bashrc.custom" >> "$HOME/.bashrc"
  else
    echo "source $HOME/.bashrc.custom" > "$HOME/.bashrc"
  fi
}

function link_misc() {
  local _miscfong_="${1:-$HOME/Configs/misc}"
  _miscfong_="${_miscfong_%/}"

  mkdir -p "$HOME/.ssh"
  backup_and_link "$_miscfong_/ssh_config" "$HOME/.ssh/config"

  backup_and_link "$PWD/notes" "$HOME/Notes"

  mkdir -p "$HOME/.config/terminator"
  backup_and_link "$_miscfong_/terminator_config" "$HOME/.config/terminator/config"

  backup_and_link "$_miscfong_/.inputrc" "$HOME/.inputrc"
  backup_and_link "$_miscfong_/.gitconfig-linux" "$HOME/.gitconfig"
  backup_and_link "$_miscfong_/.gitignore" "$HOME/.gitignore"
  backup_and_link "$_miscfong_/git-new-workdir" "$HOME/.local/bin/git-new-workdir"

  if [[ -f "$HOME/.google" ]]; then
    backup_and_link "$_miscfong_/.git5rc" "$HOME/.git5rc"
    backup_and_link "$_miscfong_/.dremelrc" "$HOME/.dremelrc"
    backup_and_link "$_miscfong_/.blazerc" "$HOME/.blazerc"
  fi
}

function link_tmux() {
  local _tmuxconf_="${1:-$HOME/Configs/tmux}"
  _tmuxconf_="${_tmuxconf_%/}"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.linux" "$HOME/.tmux.conf.local"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    backup_and_link "$_tmuxconf_/.tmux.conf.mac" "$HOME/.tmux.conf.local"
  fi

  backup_and_link "$_tmuxconf_/.tmux-default.conf" "$HOME/.tmux-default.conf"
  backup_and_link "$_tmuxconf_/.tmux.conf" "$HOME/.tmux.conf"
  backup_and_link "$_tmuxconf_/.tmux.extra.conf" "$HOME/.tmux.extra.conf"
  backup_and_link "$_tmuxconf_/mux-config" "$HOME/.local/bin/mux-config"

  mkdir -p "$HOME/.tmuxinator"
  backup_and_link "$_tmuxconf_/project.yml.template" "$HOME/.tmuxinator/project.yml.template"
}

function link_utils() {
  local _utilsconf_="${1:-$HOME/Configs/utils}"
  _utilsconf_="${_utilsconf_%/}"

  mkdir -p "$HOME/.utils"
  backup_and_link "$_utilsconf_/awk/flldu.awk" "$HOME/.utils/flldu.awk"
  backup_and_link "$_utilsconf_/awk/lsdu.awk" "$HOME/.utils/lsdu.awk"
  backup_and_link "$_utilsconf_/lldu.awk" "$HOME/.utils/lldu.awk"
}

function link_vim() {
  local _vimconf_="${1:-$HOME/Configs/vim}"
  _vimconf_="${_vimconf_%/}"

  backup_and_link "$_vimconf_/.gvim.sh" "$HOME/.gvim.sh"
  backup_and_link "$_vimconf_/.gvimrc" "$HOME/.gvimrc"
  backup_and_link "$_vimconf_/.vimrc" "$HOME/.vimrc"

  if [[ -f "$HOME/.google" ]]; then
    backup_and_link "$_vimconf_/.vimrc.google" "$HOME/.vimrc.local"
  elif [[ -f "$HOME/.glaptop" ]]; then
    backup_and_link "$_vimconf_/.vimrc.glaptop" "$HOME/.vimrc.local"
  else
    backup_and_link "$_vimconf_/.vimrc.personal" "$HOME/.vimrc.local"
  fi
}

function link_zsh() {
  local _zshconf_="${1:-$HOME/Configs/zsh}"
  _zshconf_="${_zshconf_%/}"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  fi

  _zshcustom_="$HOME/.zshcustom"
  mkdir -p "$_zshcustom_"

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_zshconf_/linux-gnu.zsh" "$_zshcustom_/platform.zsh"
    backup_and_link "$_zshconf_/plugins.linux-gnu.zsh" "$_zshcustom_/plugins.zsh"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    backup_and_link "$_zshconf_/mac.zsh" "$_zshcustom_/platform.zsh"
    backup_and_link "$_zshconf_/plugins.mac.zsh" "$_zshcustom_/plugins.zsh"
  fi

  backup_and_link "$_zshconf_/.zshrc" "$HOME/.zshrc"
  backup_and_link "$_zshconf_/zshenv" "$HOME/.zshenv"
  backup_and_link "$_zshconf_/custom.zsh" "$_zshcustom_/custom.zsh"
  if [[ ! -h "$_zshcustom_/themes" ]]; then
    ln -s "$_zshconf_/themes" "$_zshcustom_/themes"
  fi

  if [[ -f "$HOME/.google" ]]; then
    backup_and_link "$_zshconf_/google.zsh" "$_zshcustom_/local.zsh"
    backup_and_link "$_zshconf_/google.zshenv" "$HOME/.zshenv"
  else
    backup_and_link "$_zshconf_/glaptop.zsh" "$_zshcustom_/local.zsh"
  fi
}

function link_x11() {
  local _x11conf_="${1:-$HOME/Configs/x11}"
  _x11conf_="${_x11conf_%/}"

  backup_and_link "$_x11conf_/.xinitrc" "$HOME/.xinitrc"
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    backup_and_link "$_x11conf_/.Xmodmap.linux-gnu" "$HOME/.Xmodmap"
  # elif [[ "$OSTYPE" == "darwin"* ]]; then
    # backup_and_link "$_x11conf_/.Xmodmap.mac" "$HOME/.Xmodmap"
  fi
}

function link_ctags() {
  local _ctagsconf_="${1:-$HOME/Configs/ctags}"
  _ctagsconf_="${_ctagsconf_%/}"

  backup_and_link "$_ctagsconf_" "$HOME/.ctagscnf"
}

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
