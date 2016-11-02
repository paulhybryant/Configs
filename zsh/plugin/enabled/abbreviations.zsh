# Adopted from http://stackoverflow.com/questions/28573145/how-can-i-move-the-cursor-after-a-zsh-abbreviation
# Source: https://github.com/ericboehs/dotfiles/blob/master/.zsh/abbreviations.zsh
# http://zshwiki.org/home/examples/zleiab

setopt extendedglob

typeset -Ag abbrevs
abbrevs=(
  '...'       '../..'
  '....'      '../../..'
  'cx'        'chmod +x'
  'da'        'du -sch'
  'lad'       'ls -d .*(/)\n# only show dot-directories'
  'lb'        'listabbrevs'
  'lsa'       'ls -a .*(.)\n# only show dot-files'
  'lsbig'     'ls -flh *(.OL[1,10])\n# display the biggest files'
  'lsd'       'ls -d *(/)\n# only show directories'
  'lse'       'ls -d *(/^F)\n# only show empty directories'
  'lsl'       'ls -l *(@[1,10])\n# only symlinks'
  'lsnew'     'ls -rl *(D.om[1,10])\n# display the newest files'
  'lsold'     'ls -rtlh *(D.om[-11,-1])\n# display the oldest files'
  'lss'       'ls -l *(s,S,t)\n# only files with setgid/setuid/sticky flag'
  'lssmall'   'ls -Srl *(.oL[1,10])\n# display the smallest files'
  'lsw'       'ls -ld *(R,W,X.^ND/)\n# world-{readable,writable,executable} files'
  'lsx'       'ls -l *(*[1,10])\n# only executables'
  'md'        'mkdir -p '
  "awkp"      "| awk '{print \$__CURSOR__}'"
  'rlw'       'readlink $(which __CURSOR__)'
  'ta'        'tmux attach -d -t'
  'tl'        'tmux list-sessions'
  'ts'        '\tmux start-server; \tmux attach'
)

# Docker
abbrevs+=(
  "dk"    "docker"
  "dkrit" "docker run -it"
  "dki"   "docker images"
  "dkig"  "docker images | grep __CURSOR__ | awk '{print \$3}'"
  "dm"    "docker-machine"
  "dmssh" "docker-machine ssh"
  "dc"    "docker-compose"
  "dkbd"  "docker build ."
  "dkbt"  "docker build -t __CURSOR__ ."
  "drid"  "docker rmi -f \$(docker images -q -f \"dangling=true\")"
)

# Add alias and autocompleteion for hub
type compdef >/dev/null 2>&1 && compdef hub=git
type hub >/dev/null 2>&1 && alias git='hub'

for abbr in ${(k)abbrevs}; do
  alias $abbr="${abbrevs[$abbr]}"
done

magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
  command=${abbrevs[$MATCH]}
  LBUFFER+=${command:-$MATCH}

  if [[ "${command}" =~ "__CURSOR__" ]]; then
    RBUFFER=${LBUFFER[(ws:__CURSOR__:)2]}
    LBUFFER=${LBUFFER[(ws:__CURSOR__:)1]}
  else
    zle self-insert
  fi
}

magic-abbrev-expand-and-execute() {
  magic-abbrev-expand
  zle backward-delete-char
  zle accept-line
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-execute
zle -N no-magic-abbrev-expand

bindkey " " magic-abbrev-expand
bindkey "^M" magic-abbrev-expand-and-execute
bindkey "^x " no-magic-abbrev-expand
bindkey -M isearch " " self-insert
