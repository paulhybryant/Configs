#!/usr/bin/env zsh

source "${0:h}/../../lib/base.zsh"
source "${0:h}/../../lib/strings.zsh"

set -x

function test::strings::strip_slash() {
  local _ret=$(strings::strip_slash '/a/b/c/')
  [[ "${_ret}" == '/a/b/c' ]]
}
test::strings::strip_slash
