#!/usr/bin/env bash
# vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:
# Save the state of tmux sessions (including windows and panes) as tmuxinator config.

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
  DIR="$PWD";
fi
source "$DIR/tmux-session-lib.sh"

set -e

CONFIRM=
while getopts q FLAG;
do
  case $FLAG in
    q)
      CONFIRM=1
      ;;
    *)
      echo "Unknown option $FLAG"
      ;;
  esac
done
shift $(($OPTIND-1))

case "$1" in
  save )
    $1 $CONFIRM
    ;;
  * )
    echo "valid commands: save" >&2
    exit 1
esac
