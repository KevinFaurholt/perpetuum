#!/bin/bash
filename=$1;
echo "create file: $filename";

# delete existing file
if [ -f "$filename" ]; then
  echo "Rebuilding existing file : $filename ...";
  rm $filename;
fi

touch $filename;

# random number generator
FLOOR=123000;
CEILING=999999;
RANGE=$(($CEILING-$FLOOR+1));
RESULT=$RANDOM;
RESULT=$(($RESULT+$FLOOR));
#echo "Congratulations! You just generated a random number ($RESULT) the is in between $FLOOR and $CEILING (inclusive)";

array=(True False); alen=${#array[@]};

2021-02-16_14-43-07
#2020-03-04 04:00:06.473000000
echo "SubscriberKey,OptinEmailMarketing,LastModifiedAt,OptinCONNLMiete,OptinCONNLNeubau,OptinCONNLBaufi,OptinCONNLGewerbe,OptinPPANLHomeOwnerRent,OptinPPANLHomeOwnerSell,OptinCONNLEigentuemer" >> $filename;

for i in $(seq 1000); do
#for (( i=999999; i <= 1000010; i++ )) do
RESULT=$RANDOM;
RESULT=$(($RESULT+$FLOOR));
echo "\
${RESULT},\
${array[RANDOM % alen]},\
$(date +'%F %H:%M:%S.000000000'),\
${array[RANDOM % alen]},\
${array[RANDOM % alen]},\
${array[RANDOM % alen]},\
${array[RANDOM % alen]},\
${array[RANDOM % alen]},\
${array[RANDOM % alen]},\
${array[RANDOM % alen]}" | awk -v i=$i -v filename=$filename '
  BEGIN {
    FS=OFS=",";
    # awk output is given in scientific notation e.g. 1817350 > 1.81735e+06
    # print numbers as integers (rounds)
    OFMT="%.0f";
  }
  {
    $1 = sprintf("%s-%0.8d", "test", i);
    print >> filename;
  }
  END {
    #fflush :: Write any unwritten data to the file or piped stream opened by a print or printf statement
    fflush();
    close(filename);
  }
  ';
done;