#!/usr/bin/env zsh

# Setup variables
synergy_log="$HOME/.local/var/log/synergy.log"
synergy_lock="/tmp/synergy.lock"

# Initialize the state file to keep track of lines read so far from the log so
# that we can do incremental read
[[ -f ${synergy_lock} ]] || echo "0" > ${synergy_lock}

# Read the line number we stopped at last time
read line_start < ${synergy_lock}

# Count the number of lines in current log file
line_end=$(wc -l < ${synergy_log})

# Calculate the number of lines changed since the last read
num_lines=$((line_end - line_start))

# Read the new lines
newlines=$(tail -n ${num_lines} ${synergy_log})

# Update the state file
echo ${line_end} >! ${synergy_lock}

# Determine the synergy profile
profile=
echo ${newlines} | grep "entering screen" 2>&1 > /dev/null && profile="Synergy"
echo ${newlines} | grep "leaving screen" 2>&1 > /dev/null && profile="OSX"

# Switch profile
[[ -z ${profile} ]] || \
  noti -t "Karabiner" -m "Switched profile to '${profile}'" \
  /Applications/Karabiner.app/Contents/Library/bin/karabiner \
  select_by_name ${profile}

exit 0
