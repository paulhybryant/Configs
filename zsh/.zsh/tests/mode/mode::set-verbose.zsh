#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::mode::set-verbose() {
  mode::set-verbose 10
  mode::verbose 10
  [[ $? -eq 0 ]]
  mode::verbose 9
  [[ $? -eq 0 ]]
  mode::verbose 11
  [[ $? -eq 1 ]]
}
test::mode::set-verbose
