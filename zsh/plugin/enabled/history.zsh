# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

declare -xg HIST_STAMPS='yyyy-mm-dd' HISTFILE="$HOME/.zsh_history"
# case $HIST_STAMPS in
  # 'mm/dd/yyyy') alias history='fc -fl 1' ;;
  # 'dd.mm.yyyy') alias history='fc -El 1' ;;
  # 'yyyy-mm-dd') alias history='fc -il 1' ;;
  # *) alias history='fc -l 1' ;;
# esac
# setopt INC_APPEND_HISTORY      # Append history immediatly instead of wait until shell exits.
setopt NO_APPEND_HISTORY
setopt HIST_ALLOW_CLOBBER
setopt HIST_FCNTL_LOCK
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line being added to the history list
