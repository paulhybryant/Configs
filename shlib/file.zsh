# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

source ${__MYZSHLIB__}/base.zsh
base::should_source ${0:a} $__FILE__ || return
__FILE__="$(base::script_signature ${0:a})"

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

function file::ll() {
  ls -lh "$@"
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
  }' <<< "$(ls -l $@)"
}
alias ll=file::ll

function file::la() {
  ls -alF "$@"
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
  }' <<< "$(ls -laF $@)"
}
alias la=file::la

function file::ldu() {
  $1
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
  }' <<< "$($2 $@)"
}
alias ldu=file::ldu
