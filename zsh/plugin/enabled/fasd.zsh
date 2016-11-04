# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d -i'     # directory
alias f='fasd -f -i'     # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias v='f -e vim'

# function z() {
  # local dir
  # dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
# }
