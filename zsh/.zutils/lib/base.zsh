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
The check order is the following:
1. Variable or Function
2. Binary
3. File or Directory

$1 The thing to be checked whether it exists.

@return 0 or 1. 0 exists, 1 not exists.
=cut
function base::exists() {
  eval "[[ -n \${$1+1} ]]" && return 0
  whence "$1" > /dev/null && return 0
  [[ -e "$1" || -d "$1" ]] && return 0
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
  # Note the quotes around '$_opts': they are essential!
  eval set -- "${_opts}"
  local _var
  _fn_options=()
  while true; do
    case "$1" in
      -- ) shift; break ;;
      -* ) _var="$1"; _fn_options[${_var}]="true"; shift ;;
      * ) [[ -z ${_var} ]] && break; _fn_options[${_var}]="$1" && _var=''; shift ;;
   esac
  done
}

: <<=cut
=back
=cut
