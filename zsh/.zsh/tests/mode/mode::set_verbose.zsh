#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::mode::set-verbose() {
  mode::set-verbose 10
  [[ "${__VERBOSE__}" -eq 10 ]]
}
test::mode::set-verbose
