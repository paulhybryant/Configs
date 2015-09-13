#!/usr/bin/env zsh

source "../../init.zsh"
source "../../strings.zsh"

set -x

function test::strings::strip_slash() {
  local _ret=$(strings::strip_slash '/a/b/c')
  [[ "${_ret}" == '/a/b/c' ]]
}
test::strings::strip_slash
