#!/usr/bin/env zsh

source "${__MYZSHLIB__}/common.sh"

local -a dirty_repos
dirty_repose=()
for dir in */; do
  msg "Checking " ${dir}
  pushd ${dir}
  git dirty
  if [[ $? -ne 0 ]]; then
    dirty_repos+=${dir}
  fi
  popd
done

if [[ ${#dirty_repos} -gt 0 ]]; then
  err "Dirty repos found!"
  for dir in ${dirty_repos}; do
    err "Repo: ${dir}"
  done
fi
