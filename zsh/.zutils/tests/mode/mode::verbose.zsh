#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/mode.zsh"

set -x

function test::mode::verbose() {
  mode::set_verbose 1
  mode::verbose 0
  [[ $? -eq 0 ]]
  mode::verbose 2
  [[ $? -eq 1 ]]
}
test::mode::verbose
