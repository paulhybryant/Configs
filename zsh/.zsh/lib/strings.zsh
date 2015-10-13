# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: strings.zsh - Utility functions for string manipulation.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

source "${0:h}/base.zsh"

: <<=cut
=item Function C<strings::strip_slash>

Strip trailing slash in the string.

$1 The string to apply the strip operation

@return the result string after stripping
=cut
function strings::strip_slash() {
  if [[ "$1" =~ .*/$ ]]; then
    echo "${1%/}"
  else
    echo "$1"
  fi
}

: <<=cut
=item Function C<strings::join>

Join string with delimiter and prefix.

@return The resulting string after joining.
=cut
function strings::join() {
  setopt localoptions err_return
  local -A _fn_options
  _fn_options=(--delim ',' --prefix '')
  local -a _fn_args
  _fn_args=("${(@M)@:#-*}")
  base::parseargs

  _args=("${(@)@:#-*}")
  setopt localoptions nounset
  local _result
  for part in ${_args}; do
    if [[ -z "${_result}" ]]; then
      _result="${_fn_options[--prefix]}${part}"
    else
      _result="${_result}${_fn_options[--delim]}${_fn_options[--prefix]}${part}"
    fi
  done
  echo "${_result}"
}

: <<=cut
=back
=cut
