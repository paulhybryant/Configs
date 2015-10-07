#!/usr/bin/env zsh

source "${0:h}/../../lib/init.zsh"
source "${0:h}/../../lib/base.zsh"
source "${0:h}/../../lib/mode.zsh"

set -x

function test::mode::toggle_dryrun() {
}
test::mode::toggle_dryrun

function test::mode::dryrun() {
  mode::dryrun
  [[ $? -eq 1 ]] || return 1

  mode::toggle_dryrun
  mode::dryrun
  [[ $? -eq 0 ]] || return 1

  mode::toggle_dryrun
  mode::dryrun
  [[ $? -eq 1 ]] || return 1

  return 0
}
test::mode::dryrun
