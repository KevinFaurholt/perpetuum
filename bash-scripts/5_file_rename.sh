#!/bin/bash

# copy: cp -R <source_folder> <destination_folder>
# del: rm -R <source_folder>

#Bash Parameter Expansion Cheatshee
#https://www.xaprb.com/media/2007/03/bash-parameter-expansion-cheatsheet.pdf

for i in *.csv; do
  echo "$(echo ${i%.*} | awk -F "." ' { print sprintf("%s-%s", $0, "v2"); }').csv";
  #mv "$i" "$(echo ${i%.*} | awk -F "." ' { print sprintf("%s-%s", $0, "v2"); }').csv";
  cp "$i" "$(echo ${i%.*} | awk -F "." ' { print sprintf("%s-%s", $0, "v2"); }').csv";
done