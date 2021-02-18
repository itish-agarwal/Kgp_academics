#! /bin/bash 

IFS=, read -ra args<<<$1
if [[ ${#args[@]} != [1-9] ]];then
    echo "Wrong number of inputs"
    exit
fi

ans=${args[0]}
for b in ${args[@]}
do
    (( b=${b#-} ))
    while [[ $b -ne 0 ]];do
        temp=$ans
        ans=$b
        (( b=temp%b ))
    done
done    
echo $ans

