#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/mode.zsh"

set -x

function test::mode::dryrun() {
  mode::dryrun
  [[ $? -eq 1 ]]
  mode::toggle_dryrun
  mode::dryrun
  [[ $? -eq 0 ]]
  mode::toggle_dryrun
  mode::dryrun
  [[ $? -eq 1 ]]
}
test::mode::dryrun
