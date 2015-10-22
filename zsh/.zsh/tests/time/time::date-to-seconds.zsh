#!/usr/bin/env zsh

fpath+=(${0:h}/../../lib/)
autoload -Uz -- ${0:h}/../../lib/[^_]*(:t)

set -x

function test::time::date-to-seconds() {
  local _date='Sun Sep 13 19:24:02 CST 2015'
  local _time='1442143442'
  local _ret=$(time::date-to-seconds "${_date}")
  [[ "${_time}" == "${_ret}" ]]
  _date='20150913 19:24:02'
  _ret=$(time::date-to-seconds "${_date}")
  [[ "${_time}" == "${_ret}" ]]
}
test::time::date-to-seconds
