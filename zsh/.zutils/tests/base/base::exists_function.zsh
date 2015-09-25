#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"

set -x

function test::base::function_exists() {
  function test::__foo__() {
    ;
  }
  base::exists test::__foo__
}
test::base::function_exists
