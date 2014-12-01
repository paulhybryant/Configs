#!/bin/bash

TABLENAME=$1
FILENAMES=$2
SCHEMAFILE=$3

awk -f ~/utils/awk/csvtabledef.awk -v tablename=$TABLENAME -v file_names=$FILENAMES $SCHEMAFILE | tee /tmp/$TABLENAME.tabledef
