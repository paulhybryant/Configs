# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

: <<=cut
=pod

=head1 NAME

File: file.zsh -

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 Methods

=over 4
=cut

init::sourced "${0:a}" && return

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
function file::find_ignore_git() {
  file::find_ignore_dir ".git"
}
function file::rm() {
  trash $@
}
function file::ll() {
  eval "${aliases[ls]:-ls} -lh $*"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      for(i = 5; y < 1; i--)
        y = sum / (2^(10*i))
      printf("Total size (files only): %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< $(eval "${aliases[ls]:-ls} -l $*")
}
function file::la() {
  eval "${aliases[ls]:-ls} -alF $*"
  awk '/^-/ {
    sum += $5
    ++filenum
  }
  END {
    if (filenum > 0) {
      split("B KB MB GB TB PB", type)
      for(i = 5; y < 1; i--)
        y = sum / (2^(10*i))
      printf("Total size (files only): %.1f %s, %d files.\n", y, type[i+2], filenum)
    }
  }' <<< $(eval "${aliases[ls]:-ls} -laF $*")
}
function file::softlink() {
  local _src=$1
  local _target=$2

  if [[ -h "${_target}" ]]; then
    # Remove existing symlink
    rm "${_target}"
  elif [[ -f "${_target}" || -d "${_target}" ]]; then
    echo "${_target} is an existing file / directory."
    return 1
  fi
  ln -s "${_src}" "$_target"
}

: <<=cut
=back
=cut
