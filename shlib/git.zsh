# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

init::sourced ${0:a} && return

source ${0:h}/io.zsh

# Check subdirs of current directory, and report repos that are dirty
function git::check_dirty_repos() {
  local -a dirty_repos
  dirty_repose=()
  for dir in */; do
    io::msg "Checking " ${dir}
    pushd ${dir}
    git dirty
    if [[ $? -ne 0 ]]; then
      dirty_repos+=${dir}
    fi
    popd
  done

  if [[ ${#dirty_repos} -gt 0 ]]; then
    io::err "Dirty repos found!"
    for dir in ${dirty_repos}; do
      io::err "Repo: ${dir}"
    done
  fi
}

function git::has_branch() {
  [[ -n $(git branch --list "$1") ]] && return 0
  return 1
}

# Get parent branch of a branch, defaults to current branch.
# How it works:
# 1| Display a textual history of all commits.
# 2| Ancestors of the current commit are indicated
#    by a star. Filter out everything else.
# 3| Ignore all the commits in the current branch.
# 4| The first result will be the nearest ancestor branch.
#    Ignore the other results.
# 5| Branch names are displayed [in brackets]. Ignore
#    everything outside the brackets, and the brackets.
# 6| Sometimes the branch name will include a ~2 or ^1 to
#    indicate how many commits are between the referenced
#    commit and the branch tip. We don't care. Ignore them.
function git::parent_branch() {
  if [[ $# -eq 0 ]]; then
    local _branch=$(git rev-parse --abbrev-ref HEAD)
  else
    local _branch=$1
  fi
  git show-branch | ack '\*' | ack -v "$_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}
