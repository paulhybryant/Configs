#!/usr/bin/env bash

# DEBUG=true
LOGFILE=/tmp/log.txt

function get_active_win_geometry() {
  local _id_=$(xdotool getactivewindow)
  while read -a a;
    do
      w=${a[0]};
      if (($((16#${w:2}))==_id_)); then
        WIN_X=${a[3]}
        WIN_Y=${a[4]}
        WIN_W=${a[5]}
        WIN_H=${a[6]}
        if [[ $DEBUG == true ]]; then
          echo $WIN_X $WIN_Y $WIN_W $WIN_H >> $LOGFILE
        fi
        break;
      fi;
    done < <(wmctrl -lpG)
}

function log_run() {
  if [[ $DEBUG == true ]]; then
    echo "$1" >> $LOGFILE
  fi
  $1
}

get_active_win_geometry
if [[ $DEBUG == true ]]; then
  echo "Moving to $1" >> $LOGFILE
fi

if [[ $WIN_X -ge 1920 ]]; then
  if [[ $1 == "LEFT" ]]; then
    WIN_X=$((WIN_X - 1920))
    log_run "wmctrl -r :ACTIVE: -e 0,$WIN_X,$WIN_Y,$WIN_W,$WIN_H"
  fi
else
  if [[ $1 == "RIGHT" ]]; then
    WIN_X=$((WIN_X + 1920))
    log_run "wmctrl -r :ACTIVE: -e 0,$WIN_X,$WIN_Y,$WIN_W,$WIN_H"
  fi
fi
