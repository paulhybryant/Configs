#!/usr/bin/env zsh

source "${0:h}/../../lib/init.zsh"
source "${0:h}/../../lib/io.zsh"
source "${0:h}/../../lib/mode.zsh"
source "${0:h}/../../lib/shell.zsh"

set -x

function test::shell::eval() {
  local _cmd _expected _actual
  _cmd='echo "hello world"'

  _expected='hello world'
  _actual="$(shell::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]

  mode::toggle_dryrun
  _expected=$(printf "%-${PREFIXWIDTH}s echo \"hello world\"" '[Dryrun]')
  _actual="$(shell::eval ${_cmd})"
  [[ "${_expected}" == "${_actual}" ]]
}
test::shell::eval
