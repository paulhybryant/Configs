#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::strings::strip-slash() {
  local _ret=$(strings::strip-slash '/a/b/c')
  [[ "${_ret}" == '/a/b/c' ]]
}
test::strings::strip-slash
