#!/bin/bash

filename=$1;
name=$(echo "$filename" | cut -f 1 -d '.');
echo $name;

rm TEMP*;

if [ -f "$filename" ]; then
  if [[ -s $filename ]]; then
    #split -l 100000 -a 1 master_purchases.csv purchases-
    #awk -v prefix="$name" 'NR % 20==1 { file= prefix "_" sprintf("%04d", NR+19) ".csv" } { print > file }' $filename;
    #awk -v prefix="$name" '(NR % 20==1) { file= prefix "_" sprintf("%04d", NR) ".csv" } { if (NR >= 2) print > file; }' $filename;
    #awk -v prefix="$name",count=0 'BEGIN { print "Start Processing" count }; (NR % 20==1) { print $0; }; END { print "End Processing." }' $filename;

    awk -v prefix="$name" '
      BEGIN {
        FS = ",";
        getline head;
      }
      NR % 99999 == 2 {
        if (file) {
          #fflush :: Write any unwritten data to the file or piped stream opened by a print or printf statement
          fflush(file);
          close(file);
        }
        file = "TEMP"++i;
        #files[i] = file;
        # create new file
        print head > file;
      }
      {
        # count number of unique ssoid entries
        #ssoid[$2]++;
        # append to file
        print >> file;
      }
      #END {for(j=1;j<i;j++)print> a[j];}
      END {
        #for (var in ssoid) print var, "listed", ssoid[var]," times"

        #fflush :: Write any unwritten data to the file or piped stream opened by a print or printf statement
        fflush(file);
        close(file);
      }
    ' $filename

    for file in TEMP*
    do
      #mv "$file" "vacation-$file"     
      #awk 'NR==1 { foo = $5 / 1024 / 1024 ; print FILENAME " (" FNR " rows) " foo "MB" }' $file;
      #awk -F 'END { foo = $5; print FILENAME " (" FNR " rows) " foo "MB" }' $file;
      ls -S -lh $file | awk '{print $5/1024/1024, $9}'
    done

  else
    echo "$filename is empty, nothing to do!";
  fi
else
  echo "$filename does not exist!"
fi

ls -l;