#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::time::human-readable-date() {
  local _time='1442143442'
  local _ret=$(time::human-readable-date "${_time}")
  [[ "${_ret}" == 'Sun Sep 13 19:24:02 CST 2015' ]]
}
test::time::human-readable-date
