#!/usr/bin/env zsh

fpath+=(${0:h}/../../functions/)
autoload -Uz -- ${0:h}/../../functions/[^_]*(:t)

set -x

function test::zsh::eval() {
  local _cmd _expected _actual _width
  zstyle -s ":registry:var:prefix-width" registry _width
  _cmd='printf "hello world\n"'

  _expected='hello world'
  _actual="$(zsh::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]

  mode::toggle-dryrun
  _expected=$(printf "%-${_width}s printf \"hello world\\n\"" '[Dryrun]')
  _actual="$(zsh::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]
}
test::zsh::eval
