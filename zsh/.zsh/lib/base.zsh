# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: base.zsh - Basic utiliti functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

: <<=cut
=item Function C<base::parseargs>

Parse arguments passed to functions.
Assuming the existence of two variables:
  _fn_options - Containing the default options and default option values for this function
  _fn_args - Arguments passed to this function

Example:
  local -A _fn_options
  _fn_options=(--no-detached 'null' --foo 'null' --unset 'empty')
  local -a _fn_args
  _fn_args=(--no-detached --foo=y)
  base::parseargs
  [[ ${_fn_options[--no-detached]} == "true" ]]
  [[ ${_fn_options[--foo]} == "y" ]]
  [[ ${_fn_options[--unset]} == "empty" ]]

@return NULL
=cut
function base::parseargs() {
  setopt localoptions err_return
  local _arg _argv _kv
  for arg in ${_fn_args}; do
    _arg=
    _argv=
    if [[ "${arg}" =~ '.*=.*' ]]; then
      _kv=("${(s/=/)arg}")
      _arg=${_kv[1]}
      _argv=${_kv[2]}
    else
      _arg=${arg}
    fi
    if [[ ${+_fn_options[${_arg}]} -eq 0 ]]; then
      printf "Available options: ${(k)_fn_options}\n"
      printf "${COLOR_Red}Invalid options: ${_arg}\n${COLOR_Color_Off}"
      return 1
    fi
    if [[ -z "${_argv}" ]]; then
      _fn_options[${_arg}]="true"
    else
      _fn_options[${_arg}]="${_argv}"
    fi
  done
}

: <<=cut
=item Function C<base::getopt>

Use gnu getopt to parse long function arguments.

Example:
  local -A _fn_options
  base::getopt no-detached,foo:,unset: --no-detached --foo yo
  _fn_options[--no-detached] == "true"
  _fn_options[--foo] == "yo"
  _fn_options[--unset] == ""

@return NULL
=cut
function base::getopt() {
  setopt localoptions err_return
  local _opts _short _long
  _long="$1"
  shift
  # _opts=$(getopt -o vnyhu --long verbose,dryrun,noconfirm,help,usage -n 'muxcfg' -- "$@")
  _opts=$(${CMDPREFIX}getopt -o '' --long "${_long}" -- "$@" || exit 1)
  # Note the quotes around '${_opts}': they are essential!
  eval set -- "${_opts}"
  local _var
  _fn_options=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -- )
        [[ ! -z "${_var}" ]] && _fn_options[${_var}]="true" && _var=''
        _var=''
        shift
        ;;
      --* )
        [[ ! -z "${_var}" ]] && _fn_options[${_var}]="true"
        _var="$1"
        shift
        ;;
      * )
        if [[ -z ${_var} ]]; then
          _fn_args+=($1)
        else
          _fn_options[${_var}]="$1" && _var=''
        fi
        shift
        ;;
   esac
  done
}

: <<=cut
=item Function C<time::getmtime>

Get last modification time of a file.
$1 Filename

@return string of the last modified time of a file.
=cut
function time::getmtime() {
  local _mtime
  if [[ "$OSTYPE" == "darwin"* ]]; then
    _mtime="$(\stat -f '%m' $1)"
  else
    _mtime="$(\stat -c '%Y' $1)"
    # $(${CMDPREFIX}date -r "$1" +%s)
  fi
  echo "${_mtime}"
}

: <<=cut
=item Function C<base::sourced>

$1 Absolute path to the file to be sourced.

@return 0 or 1, indicates whether latest version of this file is sourced.
=cut
function base::sourced() {
  (( ${+functions[io::vlog]} )) && io::vlog 1 "Trying to source ${1:t}"
  local _ltime
  zstyle -s ":mycfg:module:${${1:t}%.zsh}" loaded _ltime
  _mtime="$(time::getmtime $1)"
  if [[ "${_ltime}" == "$_mtime" ]]; then
    (( ${+functions[io::vlog]} )) && io::vlog 1 "${1:t} already sourced, timestamp: ${_ltime}"
    return 0
  else
    (( ${+functions[io::vlog]} )) && io::vlog 1 "sourcing ${1:t}, timestamp: ${_mtime}"
    zstyle ":mycfg:module:${${1:t}%.zsh}" loaded "${_mtime}"
    return 1
  fi
}

: <<=cut
=back
=cut
