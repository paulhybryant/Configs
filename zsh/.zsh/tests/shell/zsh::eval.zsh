#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::zsh::eval() {
  local _cmd _expected _actual
  _cmd='printf "hello world\n"'

  _expected='hello world'
  _actual="$(zsh::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]

  mode::toggle-dryrun
  _expected=$(printf "%-${PREFIXWIDTH}s printf \"hello world\\n\"" '[Dryrun]')
  _actual="$(zsh::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]
}
test::zsh::eval