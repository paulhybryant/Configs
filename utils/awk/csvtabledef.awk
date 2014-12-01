# Given a file with each line being fieldName-type pair separated by ",",
# this awk script generates the table def for the csv shards.
BEGIN {x=0; FS=","; print "DEFINE TABLE " tablename " <<EOF"; print "csv:"; print "file_names: \"" file_names "\"";}
{gsub(/"/, ""); gsub(/ /, ""); gsub(/\(/, ""); gsub(/\),/,"");}
{IGNORECASE = 1; gsub(/datetime/, "STRING")}
{print "columns{", "name:", "\"" $1 "\"", "type:", $2, "position:", x, "}"; x++}
END {print "EOF;"}
