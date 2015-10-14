#!/bin/bash
# Usage: dump_tsl.sh [event_uids]
#        [event_uids] event uid with "," as the delimiter
# Example: dump_tsl.sh "a,b,c,d"

EVENT_UIDS=$1

OIFS=$IFS
IFS=','

for uid in $EVENT_UIDS
do
  tsl_client --query="DESC EVENT $uid;" > /tmp/$uid.txt
  SCRIPT_ID=`cat /tmp/$uid.txt | awk '{if ($0 ~ /^RUN [0-9a-fA-F_]+/) {print $2;}}' | sed -e "s/(.*//g"`
  tsl_client --query="DESC SCRIPT $SCRIPT_ID;" > /tmp/$SCRIPT_ID.txt
  awk '/DO/,/DONE/{if (!/DO/&&!/DONE/)print}' /tmp/$SCRIPT_ID.txt > "/tmp/$uid.dsl"
done

IFS=$OIFS

# for uid in $EVENT_UIDS
# do
#   echo "DESC EVENT $uid;" >> $EVENT_QUERIES
# done


# Get event definitions
# tsl_client --query_file=$EVENT_QUERIES > $EVENT_FILE

# Extract script ids
# cat $EVENT_FILE | awk '{if ($0 ~ /^RUN [0-9a-fA-F_]+/) {print $2; }}' | sed -e "s/(.*//g" >> $SCRIPTID_FILE

# while read SID; do
#  echo "DESC SCRIPT $SID;" >> $SCRIPTS_QUERIES
# done < "$SCRIPTID_FILE"

# tsl_client --query_file=$SCRIPTS_QUERIES > $SCRIPTS_FILE

# awk '/DO/,/DONE/{if (!/DO/&&/DONE/)}' $SCRIPTS_FILE


# tsl_client --query="DESC EVENT ValidateServiceChannelInXPDailyCurrentStats" | awk '{if ($0 ~ /^RUN [0-9a-fA-F_]+/) { print $2; }}' | sed -e "s/(.*//g)"

# awk 'NR==1,/DO/{next}/DONE/,NR==0{next}{print}'
