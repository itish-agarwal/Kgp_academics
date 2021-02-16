#! /bin/bash

if [[ "$#" -ne 2 || $2 != [1-4] ]]
then
    echo "Invalid input format"
    exit
fi

if [ ! -f "$1" ]
then
    echo "Input file not found"
    exit
fi

cat "$1"|awk -v var="$2" '{print $var}'|sort -f|uniq -ic|sort -nr -k1,1|awk '{print tolower($2),$1}' >> "1e_output_${2}_column.freq" 

