#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::base::sourced() {
  base::sourced "testdata/foo.zsh"
  [[ $? -eq 1 ]]
  base::sourced "testdata/foo.zsh"
  [[ $? -eq 0 ]]
  touch testdata/foo.zsh
  base::sourced "testdata/foo.zsh"
  [[ $? -eq 1 ]]
}
test::base::sourced
