#!/usr/bin/env zsh

source "${0:h}/../../lib/init.zsh"
source "${0:h}/../../lib/mode.zsh"

set -x

function test::mode::set_verbose() {
  mode::set_verbose 10
  [[ "${__VERBOSE__}" -eq 10 ]]
}
test::mode::set_verbose
