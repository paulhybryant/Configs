# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: shell.zsh - Utilities for shell

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

source "${0:h}/base.zsh"
source "${0:h}/io.zsh"
source "${0:h}/mode.zsh"

: <<=cut
=item Function C<shell::eval>

Eval the strings, and output logs based on verbose level.

@return NULL
=cut
function shell::eval() {
  setopt localoptions err_return nounset
  if mode::dryrun; then
    printf "%-${PREFIXWIDTH}s $*\n" "[Dryrun]"
  else
    eval "$*"
  fi
}

: <<=cut
=item Function C<shell::exists>

Examples
  shell::exists --var "VAR"

Check whether something 'exists'

$1 The thing to be checked whether it exists.

@return 0 or 1. 0 exists, 1 not exists.
=cut
function shell::exists() {
  setopt localoptions unset
  local -A _fn_options
  base::getopt var:,bin:,sub:,file:,dir: "$@"

  if [[ ! -z ${_fn_options[--var]} ]]; then
    [[ ! -z ${_fn_options[--var]} ]] && eval "[[ -n \${${_fn_options[--var]}+1} ]]" && return 0
  elif [[ ! -z ${_fn_options[--bin]} ]]; then
    [[ ! -z ${_fn_options[--bin]} ]] && whence "${_fn_options[--bin]}" > /dev/null && return 0
  elif [[ -z ${_fn_options[--sub]} ]]; then
    [[ ! -z ${_fn_options[--sub]} ]] && whence -f "${_fn_options[--sub]}" > /dev/null && return 0
  elif [[ ! -z ${_fn_options[--file]} ]]; then
    [[ ! -z ${_fn_options[--file]} && -e "${_fn_options[--file]}" ]] && return 0
  elif [[ ! -z ${_fn_options[--dir]} ]]; then
    [[ ! -z ${_fn_options[--dir]} && -d "${_fn_options[--dir]}" ]] && return 0
  fi
  return 1
}

: <<=cut
=back
=cut
