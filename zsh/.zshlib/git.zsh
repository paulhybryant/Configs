# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: git.zsh - Git related utility functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

export GIT_EDITOR='vim'

: <<=cut
=item Function C<git::check_dirty_repos>

Check subdirs of current directory, and report repos that are dirty
Number of arguments accepted: 1
$check_detached 0 or 1

@return NULLPTR
=cut
function git::check_dirty_repos() {
  setopt localoptions err_return
  local -A _fn_options
  _fn_options=(--no-detached '')
  local -a _fn_args
  _fn_args=("${(@M)@:#-*}")
  base::parseargs

  setopt localoptions nounset
  [[ "${_fn_options[--no-detached]}" == "true" ]] && \
    io::msg "Considering detached as dirty."
  local -a dirty_repos
  dirty_repos=()
  for dir in */; do
    io::vlog 2 "[${0:t}] Checking ${dir}"
    pushd "${dir}"
    if [[ -d '.git' && (-n $(git status --porcelain) || \
      ("${_fn_options[--no-detached]}" == "true" && \
       "$(git status)" =~ '^HEAD detached.*')) ]]; then
      dirty_repos+=${dir}
    fi
    popd
  done

  if [[ ${#dirty_repos} -gt 0 ]]; then
    io::hl "${#dirty_repos} dirty repo(s) found!"
    for dir in ${dirty_repos}; do
      io::hl "Dirty repo: ${dir}"
    done
  else
    io::msg "All clean!"
  fi
}

: <<=cut
=item Function C<git::has_branch>

Whether a branch exists in current depo.

@return 0 if exists, 1 otherwise.
=cut
function git::has_branch() {
  setopt localoptions err_return
  [[ -n $(git branch --list "$1") ]]
}

: <<=cut
=item Function C<git::parent_branch>

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

@return NULL
=cut
function git::parent_branch() {
  local _branch
  if [[ $# -eq 0 ]]; then
    _branch=$(git rev-parse --abbrev-ref HEAD)
  else
    _branch=$1
  fi
  git show-branch | ack '\*' | ack -v "$_branch" | head -n1 | sed 's/.*\[\(.*\)\].*/\1/' | sed 's/[\^~].*//'
}

: <<=cut
=item Function C<git::new_workdir>

Create a new git working dir based on existing repo, and create a new branch in
the new workign dir.

$1 Source git working directory
$2 New git working directory
$3 New branch name

@return NULL
=cut
function git::new_workdir() {
  setopt localoptions err_return
  local -A _fn_options
  _fn_options=(-src '' -dst '' -branch '')
  local -a _fn_args
  _fn_args=("${(@M)@:#-*}")
  base::parseargs

  for arg in ${(k)_fn_options}; do
    [[ -z ${_fn_options[${arg}]} ]] && io::err "Missing required argument ${arg}"
  done
  local _orig_git=${_fn_options[-src]}
  local _new_workdir=${_fn_options[-dst]}
  local _branch=${_fn_options[-branch]}

  # want to make sure that what is pointed to has a .git directory ...
  local _git_dir
  _git_dir=$(cd "${_orig_git}" && git rev-parse --git-dir)

  case "${_git_dir}" in
  .git)
    _git_dir="${_orig_git}/.git"
    ;;
  .)
    _git_dir=${_orig_git}
    ;;
  esac

  # don't link to a configured bare repository
  if git --git-dir="${_git_dir}" config --bool --get core.bare; then
    io::err "\"${_git_dir}\" has core.bare set to true," \
      " remove from \"${_git_dir}/config\" to continue."
    return 1
  fi

  # don't link to a workdir
  if [[ -h "${_git_dir}/config" ]]; then
    io::err "\"${_orig_git}\" is a working directory only, please specify" \
      "a complete repository."
    return 1
  fi

  # don't recreate a workdir over an existing repository
  if [[ -e "${_new_workdir}" ]]; then
    io::err "destination directory '${_new_workdir}' already exists."
    return 1
  fi

  # make sure the links use full paths
  _git_dir=$(cd "${_git_dir}"; pwd)

  # create the workdir
  mkdir -p "${_new_workdir}/.git" || return 1

  # create the links to the original repo.  explicitly exclude index, HEAD and
  # logs/HEAD from the list since they are purely related to the current working
  # directory, and should not be shared.
  for x in config refs logs/refs objects info hooks packed-refs remotes rr-cache svn
  do
    case $x in
    */*)
      mkdir -p "$(dirname "${_new_workdir}/.git/$x")"
      ;;
    esac
    ln -s "${_git_dir}/$x" "${_new_workdir}/.git/$x"
  done

  # now setup the workdir
  cd "${_new_workdir}"
  # copy the HEAD from the original repository as a default branch
  cp "${_git_dir}/HEAD" .git/HEAD
  # checkout the branch (either the same as HEAD from the original repository, or
  # the one that was asked for)
  if [[ -z "${_branch}" ]]; then
    _branch=$(basename "${_new_workdir}")
  fi
  if git::has{_branch} "${_branch}"; then
    git checkout -f "${_branch}"
  else
    git checkout -f -b "${_branch}"
  fi
}

function git::submodule-url() {
  git config --list | sed -n "s@^submodule\.$1.*\.url=\(.*\)@\1@p"
}

function git::submodule-mv() {
  git submodule deinit "$1"
  git rm "$1"
  local _url
  _url=$(git::submodule-url "$1")
  git submodule add "${_url}" "$2"
}

: <<=cut
=back
=cut
