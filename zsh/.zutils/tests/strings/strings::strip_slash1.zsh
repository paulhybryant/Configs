#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/strings.zsh"

set -x

function test::strings::strip_slash() {
  local _ret=$(strings::strip_slash '/a/b/c/')
  [[ "${_ret}" == '/a/b/c' ]]
}
test::strings::strip_slash
