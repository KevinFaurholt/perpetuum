#!/bin/bash
#
# purpose: find needle(s) in a haystack of files.
# input: a csv of identifier(s) to find in the haystack
# command: find_in_files.sh NEEDLE.csv
#
SCRIPT=${0##*/};
DIR=$(pwd);
NEEDLEFILE=$1;
RESULTFILE="RESULT.csv";

clear

echo "This script: ["$SCRIPT"]";
echo "This directory: ["$DIR"]"; 
echo "Needle File: ["$NEEDLEFILE"]";
date '+START PROCESSING DATE: %d/%m/%y - TIME: %H:%M:%S'
echo "-------------------------------------------------";
rm -f $RESULTFILE;

if [ -f "$NEEDLEFILE" ]; then

	exec < $NEEDLEFILE;
	read header;
	while read line
	do
		
		#echo "line: " $line;

		IFS=',' read -a lineArray <<< "$line";
		
		for needle in "${lineArray[@]}"
		do
			for FILE in *; do

				if [[ "$FILE" == "$SCRIPT" ]]; then continue;
				elif [[ "$FILE" == "$NEEDLEFILE" ]]; then continue;
				elif [[ "$FILE" == "$RESULTFILE" ]]; then continue;
					 elif [[ "$FILE" == "find_in_files.sh" ]]; then continue;
				fi

				#echo "Searching for: " $needle "...";
				
				awk -v needle="$needle" -v quotes="'|\"" -v output="$RESULTFILE" -v date="$(date +%Y.%m.%d)" '
					BEGIN {
						FS = ",";
						OFS = ",";

						# awk output is given in scientific notation e.g. 1817350 > 1.81735e+06
		    	  # print numbers as integers (rounds)
		      	OFMT = "%.0f";
		      	
		      	getline head;
		      
						file = sprintf("%s", output);

		      	print "AWK NEEDLE TO SEARCH FOR IS: [" needle "]";

    				# remove leading spaces
    				sub(/^[ \t]+/, "", needle);

    				# remove trailing spaces
    				sub(/[ \t]+$/, "", needle);

  					# remove quotes
    				gsub (quotes, "", needle);

		      	getline line < file;
						#print "######## line is: " line "######";
    				
    				if (line == "") {
    					print head > file;
    				}
		    	}
		    	{
		    		if (NR > 1) {

		    			#print;
		  				
		  				for (i = 1; i <= NF; ++i) {

		  					val = $i;

		    				# remove leading spaces
		    				sub(/^[ \t]+/, "", val);

		    				# remove trailing spaces
		    				sub(/[ \t]+$/, "", val);

		  					# remove quotes
		    				gsub (quotes, "", val);
		    				
		    				if (val == needle) {
		    					#print("???? " val " == " needle " ????");
		    					print "match: [" $0 "]";
		    					print >> file;
		    					print "-------------------------------------------------";
		    					exit(10);
		    					#break;
		    				}
		    				else {
		    					#print val "not found";
		    				}
		  				}
		    		}
		    	}
		    	END {
		      	# Write any unwritten data to the file or piped stream opened by a print or printf statement
		      	fflush (file);
		      	close (file);
		    	}
				' $FILE;

			done
		done;
	done;
	
	date '+END PROCESSING DATE: %d/%m/%y - TIME: %H:%M:%S'

	printf %"s\n" "---------------";

	if [ -f $RESULTFILE ]; then

		COUNT=$(wc -l $RESULTFILE | awk '{ print $1 }');

		if [[ $COUNT -gt 1 ]] ; then
			COUNT=$((COUNT-1));
			echo "Found [$COUNT] needle(s) in the haystack. Results are located in $RESULTFILE";
		else
			echo "No matches in haystack!";
			rm -f $RESULTFILE;
		fi

	fi

else
	echo "Input error. You need to call script with argument!";
	echo "for example: 'find_in_files.sh needle.csv'";
fi