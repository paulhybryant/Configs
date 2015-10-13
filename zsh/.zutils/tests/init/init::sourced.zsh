#!/usr/bin/env zsh

source "${0:h}/../../lib/init.zsh"

set -x

function test::init::sourced() {
  init::loaded "testdata/foo.zsh"
  [[ $? -eq 1 ]]
  init::loaded "testdata/foo.zsh"
  [[ $? -eq 0 ]]
  touch testdata/foo.zsh
  init::loaded "testdata/foo.zsh"
  [[ $? -eq 1 ]]
}
test::init::sourced
