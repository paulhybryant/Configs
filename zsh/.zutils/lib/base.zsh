# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: base.zsh - Basic utiliti functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

: <<=cut
=item Function C<base::exists>

Examples
  base::exists "VAR"

Check whether something 'exists'

$1 The thing to be checked whether it exists.

@return 0 or 1. 0 exists, 1 not exists.
=cut
function base::exists() {
  setopt localoptions unset
  local -A _fn_options
  base::getopt v:b:s:f:d: var:,bin:,sub:,file:,dir: "$@"

  if [[ ! (-z ${_fn_options[--var]} && -z ${_fn_options[-v]}) ]]; then
    [[ ! -z ${_fn_options[--var]} ]] && eval "[[ -n \${${_fn_options[--var]}+1} ]]" && return 0
    [[ ! -z ${_fn_options[-v]} ]] && eval "[[ -n \${${_fn_options[-v]}+1} ]]" && return 0
  elif [[ ! (-z ${_fn_options[--bin]} && -z ${_fn_options[-b]}) ]]; then
    [[ ! -z ${_fn_options[--bin]} ]] && whence "${_fn_options[--bin]}" > /dev/null && return 0
    [[ ! -z ${_fn_options[-b]} ]] && whence "${_fn_options[-b]}" > /dev/null && return 0
  elif [[ ! (-z ${_fn_options[--sub]} && -z ${_fn_options[-s]}) ]]; then
    [[ ! -z ${_fn_options[--sub]} ]] && whence -f "${_fn_options[--sub]}" > /dev/null && return 0
    [[ ! -z ${_fn_options[-s]} ]] && whence -f "${_fn_options[-s]}" > /dev/null && return 0
  elif [[ ! (-z ${_fn_options[--file]} && -z ${_fn_options[-f]}) ]]; then
    [[ ! -z ${_fn_options[--file]} && -e "${_fn_options[--file]}" ]] && return 0
    [[ ! -z ${_fn_options[-f]} && -e "${_fn_options[-f]}" ]] && return 0
  elif [[ ! (-z ${_fn_options[--dir]} && -z ${_fn_options[-d]}) ]]; then
    [[ ! -z ${_fn_options[--dir]} && -d "${_fn_options[--dir]}" ]] && return 0
    [[ ! -z ${_fn_options[-d]} && -d "${_fn_options[-d]}" ]] && return 0
  fi
  return 1
}

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

Use gnu getopt to parse function arguments.

Example:
  local -A _fn_options
  base::getopt df:u: no-detached,foo:,unset: --no-detached -f yo
  [[ ${_fn_options[--no-detached]} == "true" ]]
  [[ ${_fn_options[--foo]} == "yo" ]]
  [[ ${_fn_options[--unset]} == "" ]]
  [[ ${_fn_options[-d]} == "true" ]]
  [[ ${_fn_options[-f]} == "yo" ]]
  [[ ${_fn_options[-u]} == "" ]]

@return NULL
=cut
function base::getopt() {
  setopt localoptions err_return
  local _opts _short _long
  _short="$1"
  _long="$2"
  shift 2
  # _opts=$(getopt -o vnyhu --long verbose,dryrun,noconfirm,help,usage -n 'muxcfg' -- "$@")
  _opts=$(${CMDPREFIX}getopt -o "${_short}" --long "${_long}" -- "$@")
  # Note the quotes around '${_opts}': they are essential!
  eval set -- "${_opts}"
  local _var
  _fn_options=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -- )
        [[ ! -z "${_var}" ]] && _fn_options[${_var}]="true"
        _var=''
        shift
        ;;
      -* )
        _var="$1"
        shift
        ;;
      * )
        if [[ -z ${_var} ]]; then
          _fn_args=(${_fn_args} $1)
        else
          _fn_options[${_var}]="$1" && _var=''
        fi
        shift
        ;;
   esac
  done
}

: <<=cut
=back
=cut
