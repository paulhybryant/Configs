#!/usr/bin/env zsh

source "${0:h}/../../lib/base.zsh"

set -x

function test::base::exists() {
  local -A _fn_options
  base::exists --sub test::_foo_
  [[ $? -eq 1 ]]
  function test::_foo_() {
    ;
  }
  base::exists -s test::_foo_
  [[ $? -eq 0 ]]

  base::exists --var __TEST_FOO__
  [[ $? -eq 1 ]]
  declare __TEST_FOO__
  base::exists -v __TEST_FOO__
  [[ $? -eq 0 ]]
}
test::base::exists
