#!/bin/bash
# gvim.sh
# Copyright (C) 2013 Yu Huang <paulhybryant@gmail.com>
#
# Distributed under terms of the MIT license.
#

VERBOSE=false

# Set arguments here.
# comma(:) means the option accepts an argument.
while getopts "v" Option
do
  case $Option in
    v ) VERBOSE=true ;;
  esac
done
shift $(($OPTIND - 1))

gvim_cmd="/usr/bin/env vim -g"
serverlist=`$gvim_cmd --serverlist`
serverlist=`echo $serverlist | tr '[:upper:]' '[:lower:]'`
servername=$PWD
foundgvimserver=false

if $VERBOSE; then
  echo "Running in verbose mode."
  echo "Existing vim server: $serverlist"
fi

# Open gvim if no argument is given, set servername to GVIM
if [ $# -eq 0 ]; then
  $gvim_cmd -f --servername $servername &
  exit 0
fi

shopt -s nocasematch
if [ -z "$serverlist" ]; then
  if $VERBOSE; then
    echo "Creating new vim server..."
  fi
  $gvim_cmd -f --servername $servername $1 &
  sleep 2
else
  declare -a servers=($serverlist)
  for((i = 0; i < ${#servers[@]}; i++))
  do
    if [ ${servers[i]} = $servername ];
    then
      foundgvimserver=true
    fi
  done

  if $foundgvimserver;
  then
    if $VERBOSE; then
      echo "Opening file in existing vim server..."
    fi
    $gvim_cmd -f --servername $servername --remote $1 &
  else
    if $VERBOSE; then
      echo "Opening file in new vim server..."
    fi
    $gvim_cmd -f --servername $servername $1 &
    sleep 2
  fi
fi
shopt -u nocasematch

shift
while (("$#")); do
  $gvim_cmd -f --servername $servername --remote $1 &
  sleep 1
  shift
done
