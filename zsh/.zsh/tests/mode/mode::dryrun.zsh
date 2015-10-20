#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::mode::toggle-dryrun() {
}
test::mode::toggle-dryrun

function test::mode::set-dryrun() {
}
test::mode::set-dryrun

function test::mode::dryrun() {
  mode::dryrun
  [[ $? -eq 1 ]] || return 1

  mode::toggle-dryrun
  mode::dryrun
  [[ $? -eq 0 ]] || return 1

  mode::toggle-dryrun
  mode::dryrun
  [[ $? -eq 1 ]] || return 1

  mode::set-dryrun
  mode::dryrun
  [[ $? -eq 0 ]] || return 1
  return 0
}
test::mode::dryrun
