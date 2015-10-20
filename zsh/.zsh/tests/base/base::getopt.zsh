#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::base::getopt() {
  setopt localoptions err_return
  local -A _fn_options
  local -a _fn_args
  base::getopt no-detached,foo:,unset: bar --no-detached --foo yo foooo
  [[ ${_fn_options[--no-detached]} == "true" ]]
  [[ ${_fn_options[--foo]} == "yo" ]]
  [[ ${_fn_options[--unset]} == "" ]]
  eval set -- "${_fn_args}"
  [[ "$1" == "bar" ]]
  [[ "$2" == "foooo" ]]
  unset _fn_options
}
test::base::getopt
