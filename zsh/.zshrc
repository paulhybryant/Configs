# vim: ft=zsh sw=2 ts=2 sts=2 et tw=80 fdl=0 nospell

if [[ "$OSTYPE" == "darwin"* ]]; then
  path=(~/.local/bin $BREWHOME/bin $BREWHOME/sbin \
    $BREWHOME/opt/go/libexec/bin $path)                                         # Make homebrew bin dir comes first. Reordered by path_helper in OSX.
fi

if [[ -n ${PROFILING+1} ]]; then                                                # Use PROFILING='logfile' zsh to profile the startup time
  zmodload zsh/datetime                                                         # set the trace prompt to include seconds, nanoseconds, script and line#
  PS4='+$EPOCHREALTIME %N:%i> '                                                 # PS4='+$(date "+%s:%N") %N:%i> '
  exec 3>&2 2> ${PROFILING}                                                     # save file stderr to file descriptor 3 and redirect stderr (including trace output) to a file with the script's PID as an extension
  setopt xtrace prompt_subst                                                    # set options to turn on tracing and expansion of commands in the prompt
fi

# export TERM=xterm-256color screws up HOME and END key in tmux
declare -xg XML_CATALOG_FILES="$BREWHOME/etc/xml/catalog" \
  HELPDIR="$BREWHOME/share/zsh/help" GIT_EDITOR="$EDITOR" PAGER='most' \
  GREP_OPTIONS="--color=auto" MANPAGER='most' TERM='screen-256color' \
  XDG_CACHE_HOME="$HOME/.cache" XDG_CONFIG_HOME="$HOME/.config" \
  XDG_DATA_HOME="$HOME/.local/share"
declare -xg LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen `
  `--no-init --raw-control-chars"

# Allow pass Ctrl + C(Q, S) for terminator
stty ixany && stty ixoff -ixon && stty stop undef && stty start undef
# Prevent Ctrl + D to send eof so that it can be rebind
# stty eof '' && stty eof undef && bindkey -s '^D' 'exit^M'

source ~/.antigen/repos/antigen/antigen.zsh
antigen use prezto                                                              # ZDOTDIR is set here
# antigen bundle mollifier/anyframe                                             # Wrapper for peco/percol/fzf
# antigen bundle mollifier/zload
# antigen bundle uvaes/fzf-marks
# antigen bundle mafredri/zsh-async
antigen bundle Tarrasch/zsh-colors

declare -a pmodules
zstyle ':prezto:environment:termcap' color yes
zstyle ':prezto:module:syntax-highlighting' color yes
zstyle ':prezto:module:editor' key-bindings 'vi'
pmodules=(environment directory helper editor completion git homebrew fasd \
  history syntax-highlighting clipboard linux osx tmux dpkg prompt fzf custom)  # Order matters!
pmodload "${pmodules[@]}" && unset pmodules

[[ -f ~/.antigen/.local ]] && source ~/.antigen/.local
antigen apply

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local                                # Local configurations

[[ -n ${PROFILING+1} ]] && exit 0                                               # Exit shell if it is profiling
