#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"

set -x

function test::base::exists() {
  function test::_foo_() {
    ;
  }
  base::exists test::_foo_
}
test::base::exists
