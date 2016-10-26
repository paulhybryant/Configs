#!/usr/bin/env bash

# DEBUG=true
LOGFILE=/tmp/log.txt

function log_run() {
  if [[ $DEBUG == true ]]; then
    echo "$1" >> $LOGFILE
  fi
  $1
}

function get_current_ws() {
  WSID=$(wmctrl -d | grep "\*" | cut -d' ' -f1)
  MAXWSID=$(wmctrl -d | tail -n 1 | cut -d' ' -f1)
}

get_current_ws
if [[ $DEBUG == true ]]; then
  echo "Moving to workspace $1" >> $LOGFILE
fi

if [[ $1 == "LEFT" ]]; then
  if [[ $WSID -gt 0 ]]; then
    (( WSID -= 1))
  fi
  log_run "wmctrl -r :ACTIVE: -t $WSID"
  log_run "wmctrl -s $WSID"
elif [[ $1 == "RIGHT" ]]; then
  if [[ $WSID -lt $MAXWSID ]]; then
    (( WSID += 1))
  fi
  log_run "wmctrl -r :ACTIVE: -t $WSID"
  log_run "wmctrl -s $WSID"
fi
