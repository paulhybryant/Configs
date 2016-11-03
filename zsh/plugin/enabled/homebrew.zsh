# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

alias brewdeps='brew deps --installed --tree'
alias brewg='brew graph | dot -Tpng >| /tmp/deps.png && open /tmp/deps.png'

BREWHOME=${BREWHOME:-$(brew --prefix)}
if (( $+commands[brew] )); then
  fpath=(${BREWHOME}/share/zsh/site-functions \
    ${BREWHOME}/share/zsh/site-completions $fpath)
  manpath=($BREWHOME/opt/coreutils/libexec/gnuman \
    ${BREWHOME}/share/man ${manpath[@]})
  # Tie infopath to INFOPATH, just like path to PATH
  declare -U -T INFOPATH infopath
  infopath=(${BREWHOME}/share/info $infopath)
fi
