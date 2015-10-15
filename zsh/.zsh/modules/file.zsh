# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: file.zsh - File system related utility functions.

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

(( ${+functions[base::sourced]} )) && base::sourced "${0:a}" && return 0

source "${0:h}/../lib/os.zsh"
source "${0:h}/../lib/base.zsh"
source "${0:h}/../lib/io.zsh"

: <<=cut
=item Function C<file::find_ignore_dir>

Find in current directory, with dir $1 ignored.
TODO: Make $1 an array, and ignore a list of dirs.

$1 The directory to ignore.

@return NULL
=cut
function file::find_ignore_dir() {
  # Commands with the same output
  # find . -wholename "./.git" -prune -o -wholename "./third_party" -prune -o -type f -print
  # find . -type f ! -path "./.git/*" ! -path "./third_party/*" -print
  # find . -type d \( -path './third_party*' -o -path './.git*' \) -prune -o -type f -print
  # Differences betwee these commands
  # 1. -prune stops find from descending into a directory. Just specifying
  #    -not -path will still descend into the skipped directory, but -not -path
  #    will be false whenever find tests each file.
  # 2. find prints the pruned directory
  # So performance of 1 and 3 will be better
  # find . -wholename "*/.git" -prune -o -wholename "./third_party" -prune -o "$@" -print
  find . -wholename "*/$1" -prune -o "$@" -print
}

: <<=cut
=item Function C<file::find_ignore_git>

Find in current directory, with dir .git ignored.
A shortcut for file::find_ignore_dir for git.

@return NULL
=cut
function file::find_ignore_git() {
  file::find_ignore_dir ".git"
}

: <<=cut
=item Function C<file::rm>

Use trash to remove files so it can be recovered!
Accepts rm arguments to be compatible wit rm.
Usually we define alias for it.

Examples
  source file.zsh
  alias rm=file::rm

Arguments
  Same as rm

@return NULL
=cut
function file::rm() {
  local _args='-'
  while getopts fivrdh opt
  do
    case "${opt}" in
      f|i|r|d|h)
        os::LINUX && _args="${_args}${opt}"
        ;;
      v)
        _args="${_args}${opt}"
        ;;
      *)
        trash -h
        ;;
    esac
  done
  shift $OPTIND-1
  [[ "${_args}" == "-" ]] && _args=''
  trash ${_args} "$@"
}

: <<=cut
=item Function C<file::ll>

List files in long format.

@return NULL
=cut
function file::ll() {
  eval "${aliases[ls]:-ls} -lh $*"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      y = 0
      for(i = 5; y < 1 && i > 0; i--) {
        y = sum / (2^(10*i))
      }
      printf("Total size (files only): %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< $(${CMDPREFIX}ls -lh $*)
}

: <<=cut
=item Function C<file::la>

List all files, including hidden files.

@return NULL
=cut
function file::la() {
  setopt localoptions verbose
  eval "${aliases[ls]:-ls} -aF $*"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      y = 0
      for(i = 5; y < 1 && i > 0; i--) {
        y = sum / (2^(10*i))
      }
      printf("Total size (files only): %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< $(${CMDPREFIX}ls -aF $*)
}

alias la='file::la'
alias ll='file::ll'
alias rm='file::rm'

: <<=cut
=back
=cut
