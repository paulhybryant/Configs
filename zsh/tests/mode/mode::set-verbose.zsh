#!/usr/bin/env zsh

fpath+=(${0:h}/../../functions/)
autoload -Uz -- ${0:h}/../../functions/[^_]*(:t)

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
