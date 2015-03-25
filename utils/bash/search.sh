#!/usr/bin/env bash

LOGFILE="/tmp/log.txt"
: > "$LOGFILE"
for i in $(seq -f "%05g" 0 999);
do
  echo "Reading $prefix-$i-of-01000" >> "$LOGFILE"
  result=$(gqui from $prefix-$i-of-01000 keyproto string proto string where key_=="'10000508'" --sstable_sharder=other >> "$LOGFILE")
  if [[ -n $result ]]; then
    echo "Found $result" >> "$LOGFILE"
  fi
done

