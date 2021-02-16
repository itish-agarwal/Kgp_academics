#!/bin/bash

ext=(".tar.bz2" ".tar.gz" ".bz2" ".rar" ".gz" ".tar" ".tbz2" ".tgz" ".zip" ".Z" ".7z")
commands=("tar xvjf" "tar xvzf" "bunzip2" "unrar x" "gunzip" "tar xvf" "tar xvjf" "tar xvzf" "unzip" "gunzip" "7za e")
flag=0

if [[ ! -f $1 ]]
then
    echo "Input error: File does not exist"
    exit
fi

for((i=0; i<11; ++i))
do
	if [[ $1 == *${ext[i]} ]]
	then
		flag=1
		index=$i
		break
	fi
done

if [[ flag -ne 1 ]]
then
	echo "Unknown file format: cannot extract"
else
	cmd="${commands[index]} $1"
	eval $cmd
fi
