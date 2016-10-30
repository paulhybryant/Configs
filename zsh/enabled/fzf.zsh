# vim: filetype=zsh sw=2 ts=2 sts=2 et tw=80 foldlevel=0 nospell

#
# Fzf (fuzzy finder) settings for fzf installed with homebrew / linuxbrew
#
# Authors:
#   Yu Huang <paulhybryant@gmail.com>
#

(( ${+commands[fzf]} )) || return 1

declare -xg FZF_DEFAULT_OPTS='-e'
declare -xg FZF_CTRL_T_COMMAND="command find -L . \\( -path '*/.git*' \
  -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
  -o -type f -print \
  -o -type d -print \
  -o -type l -print 2> /dev/null | sed 1d | cut -b3-"
