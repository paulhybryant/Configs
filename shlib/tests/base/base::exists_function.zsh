#!/usr/bin/env zsh

source ../../init.zsh
source ../../base.zsh

set -x

function test::base::function_exists() {
  function test::__foo__() {
    ;
  }
  base::exists test::__foo__
}
test::base::function_exists
