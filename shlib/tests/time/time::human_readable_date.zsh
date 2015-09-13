#!/usr/bin/env zsh

source "../../init.zsh"
source "../../time.zsh"

set -x

function test::time::human_readable_date() {
  local _time='1442143442'
  local _ret=$(time::human_readable_date "${_time}")
  [[ "${_ret}" == 'Sun Sep 13 19:24:02 CST 2015' ]]
}
test::time::human_readable_date
