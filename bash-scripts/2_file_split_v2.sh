#!/bin/bash

# FILE FORMAT
# SubscriberKey,OptinEmailMarketing,LastModifiedAt,OptinCONNLMiete,OptinCONNLNeubau,OptinCONNLBaufi,OptinCONNLGewerbe,OptinPPANLHomeOwnerRent,OptinPPANLHomeOwnerSell,OptinCONNLEigentuemer
# testms@test.com,True,2020-03-04 04:00:06.473000000,True,True,True,True,True,True,True
# noms@testcom,True,2020-11-06 10:54:39,True,True,True,True,True,True,True
#
# AWK Limitations:
# https://docstore.mik.ua/orelly/unix3/sedawk/ch10_08.htm#sedawk-ch-10-sect-8
#
# BEWARE POTENTIAL WINDOWS SHENANIGANS!
# https://stackoverflow.com/questions/51145796/mac-os-x-split-csv-not-working
# https://www.ezrasf.com/wplog/2019/02/27/convert-little-endian-utf-16-to-ascii/
# iconv -f utf-16 -t utf-8 filename.txt > filename_new.txt
# file filename_new.csv 
# dos2unix filename_new.csv

filename=$1;
name=$(echo "$filename" | cut -f 1 -d '.');
echo $name;

rm batch_import-*;

if [ -f "$filename" ]; then
  if [[ -s $filename ]]; then
    #split -l 100000 -a 1 master_purchases.csv purchases-
    date '+START PROCESSING DATE: %d/%m/%y - TIME: %H:%M:%S'
    awk -v filename="$filename" -v date="$(date +%Y.%m.%d)" '
      BEGIN {
        FS = ",";
        OFS = ",";

        # awk output is given in scientific notation e.g. 1817350 > 1.81735e+06
        # print numbers as integers (rounds)
        OFMT = "%.0f";

        sub(/[.]csv/, "", filename);

        getline head;
      }
      #NR % 999999 == 2 {
      NR % 99999 == 2 {
        if (file) {
          #fflush :: Write any unwritten data to the file or piped stream opened by a print or printf statement
          fflush (file);
          close (file);
        }

        #file = sprintf("%s-%s-%s-%0.3d.csv", "batch", filename, date, ++i);
        file = sprintf("%s-%s-%0.3d.csv", filename, date, ++i);
        
        touch file;

        # create new file
        #print "LineNumber" OFS head > file;
        print head > file;
      }
      {
        #lastModifiedAt = $3;
 
        # sometimes 9 ms digits are missing "2020-03-04 04:00:06.473000000"
        #if(!sub (/[.][0-9]{9}$/, "", lastModifiedAt)) {
        #  $3 = sprintf ("%s.%s", lastModifiedAt, "000000000");
        #}

        # append to file
        #print NR OFS $0 >> file;
        print >> file;

        close (file);
      }
      END {
        # Write any unwritten data to the file or piped stream opened by a print or printf statement
        fflush (file);
        close (file);
      }
    ' $filename
    date '+END PROCESSING DATE: %d/%m/%y - TIME: %H:%M:%S'

    #for file in TEMP*
    #do
      #mv "$file" "vacation-$file"     
      #awk 'NR==1 { foo = $5 / 1024 / 1024 ; print FILENAME " (" FNR " rows) " foo "MB" }' $file;
      #awk -F 'END { foo = $5; print FILENAME " (" FNR " rows) " foo "MB" }' $file;
      #ls -S -lh $file | awk '{print $5/1024/1024, $9}'
    #done

  else
    echo "$filename is empty, nothing to do!";
  fi
else
  echo "$filename does not exist!"
fi

ls -l;