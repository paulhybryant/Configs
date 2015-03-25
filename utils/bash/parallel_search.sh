#!/usr/bin/env bash

function process_sstable() {
  echo "$prefix-$1-of-01000" > /tmp/log_$1.txt
  gqui from $prefix-$1-of-01000 keyproto string proto string where key_=="'12700820'" --sstable_sharder=other |& tee /tmp/log_$1.txt
}

export -f process_sstable

parallel process_sstable ::: $(seq -f "%05g" 0 999);
