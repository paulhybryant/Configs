#!/bin/sh

if [ -s ~/.Xmodmap ]; then
  xmodmap ~/.Xmodmap
  echo "xmodmap loaded" | tee /tmp/log.txt
fi
