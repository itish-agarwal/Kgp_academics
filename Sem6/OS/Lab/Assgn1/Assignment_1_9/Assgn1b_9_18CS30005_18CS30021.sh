#! /bin/bash

if [ ! -d "1.b.files" ]
then
    echo "1.b.files does not exist"
    exit  
fi

if [ -d "1.b.files.out" ]
then
    echo "1.b.files.out already exists"
    exit
fi

mkdir "1.b.files.out"

if [ -f "1.b.out.txt" ]
then
    echo "1.b.out.txt already exists"
    exit
fi

touch "1.b.out.txt"

for item in "1.b.files"/*
do
    sort -nr $item -o "1.b.files.out"/$(basename -- $item) 
done

sort -nmr "1.b.files.out"/* -o "1.b.out.txt"
