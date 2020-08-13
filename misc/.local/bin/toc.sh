#!/bin/bash

unzip -p $1 toc.ncx | grep "<text>" | sed -e 's/<text>//' -e 's!</text>!!'
