case $HIST_STAMPS in
  'mm/dd/yyyy') alias history='fc -fl 1' ;;
  'dd.mm.yyyy') alias history='fc -El 1' ;;
  'yyyy-mm-dd') alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

alias date='${CMDPREFIX}date'
alias grepc='grep -C 5 '
alias info='info --vi-keys'
alias ls='${CMDPREFIX}ls --color=tty'
alias mank='man -K'
alias mktemp='${CMDPREFIX}mktemp'
alias nvim='NVIM=nvim nvim'
alias stat='${CMDPREFIX}stat'
alias stow='stow -v'
alias tl='tmux list-sessions'
alias tmux='TERM=screen-256color tmux -2'
alias unbindkey='bindkey -r'
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection
(( $+aliases[run-help] )) && unalias run-help                                   # Use built-in run-help to use online help
autoload run-help                                                               # Use the zsh built-in run-help function, run-help is aliased to man by default
