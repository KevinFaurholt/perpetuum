#!/bin/bash
# bash 4_file_join.sh (no args)
# echo "" | awk '!/SubscriberKey/' merged_files.csv > merged_files_unique.csv
read -p "merge file(s) pattern: " input;
fname=$(echo "$input" | cut -f 1 -d '.');
output="merged_files.csv";

rm $output;

touch $output;

for i in $(ls | grep -i "$fname");
do
	cat $i >> $output;
done
echo "Merge complete!";
echo $(wc -l "$output" | awk '{print $1}') "lines in $output";