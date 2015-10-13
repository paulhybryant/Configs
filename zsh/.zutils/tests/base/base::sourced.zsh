#!/usr/bin/env zsh

source "${0:h}/../../lib/base.zsh"

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
