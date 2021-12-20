#!/bin/bash
tail -n +2 master_purchases.csv | split -l 100000 - splitpurchases_
for file in splitpurchases_*
do
  head -n 1 master_purchases.csv > tmp_file
  cat "$file" >> tmp_file
  mv -f tmp_file "$file.csv"
  rm "$file"
done