#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"

set -x

function test::base::parseargs() {
  local -A _fn_options
  _fn_options=(--no-detached 'null' --foo 'null' --unset 'empty')
  local -a _fn_args
  _fn_args=(--no-detached --foo=y)
  base::parseargs
  [[ ${_fn_options[--no-detached]} == "true" ]]
  [[ ${_fn_options[--foo]} == "y" ]]
  [[ ${_fn_options[--unset]} == "empty" ]]
}
test::base::parseargs
