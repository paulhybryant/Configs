# vim: ft=zsh sw=2 ts=2 sts=2 et tw=80 fdl=0 nospell
if [[ -n ${PROFILING+1} ]]; then                                                # Use PROFILING='logfile' zsh to profile the startup time
  zmodload zsh/datetime                                                         # set the trace prompt to include seconds, nanoseconds, script and line#
  PS4='+$EPOCHREALTIME %N:%i> '                                                 # PS4='+$(date "+%s:%N") %N:%i> '
  exec 3>&2 2> ${PROFILING}                                                     # save file stderr to file descriptor 3 and redirect stderr (including trace output) to a file with the script's PID as an extension
  setopt xtrace prompt_subst                                                    # set options to turn on tracing and expansion of commands in the prompt
fi

# zmodload zsh/zprof
declare -xg XML_CATALOG_FILES="${BREWHOME}/etc/xml/catalog" \
  HELPDIR="${BREWHOME}/share/zsh/help" GIT_EDITOR="${EDITOR}" PAGER='most' \
  MANPAGER='most' TERM='xterm-256color' \
  XDG_CACHE_HOME="${HOME}/.cache" XDG_CONFIG_HOME="${HOME}/.config" \
  XDG_DATA_HOME="${HOME}/.local/share" \
  XDG_DATA_DIRS="${BREWHOME}/share:${XDG_DATA_DIRS}" \
  GEM_HOME="$HOME/.gems"
declare -xg LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen`
  ` --no-init --raw-control-chars"

stty ixany && stty ixoff -ixon && stty stop undef && stty start undef           # Allow pass Ctrl + C(Q, S) for terminator
# stty eof '' && stty eof undef && bindkey -s '^D' 'exit^M'                     # Prevent Ctrl + D to send eof so that it can be rebind

source ~/.zplugrc
[[ -f ~/.local/.zshrc ]] && source ~/.local/.zshrc                              # Local configurations
setopt monitor
[[ -n ${PROFILING+1} ]] && exit 0                                               # Exit shell if it is profiling
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -e ~/.p10k.zsh ]] && source ~/.p10k.zsh
return 0                                                                        # Avoid exit status 0 after zsh starts
