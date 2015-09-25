#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/mode.zsh"

set -x

function test::mode::set_verbose() {
  mode::set_verbose 10
  [[ "${__VERBOSE__}" -eq 10 ]]
}
test::mode::set_verbose
