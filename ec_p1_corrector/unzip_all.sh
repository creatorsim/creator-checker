#!/bin/bash

#set -x

if [ "$#" -lt 1 ];
then
    echo "Error. Not enough arguments.\n"
    echo "./unzip_all <group>"
    exit -1
fi

ls -1 $1 > $1.txt

LIST=$(cat $1.txt | sed 's/.zip//g')

for E in $LIST; do
	echo $E

	unzip -a -u -d $1/$E $1/$E".zip"

	#Si al descomprimir existe el subdirectorio se quita el subdirectorio extra
	if [ -d $1/$E/$E ]; then
		mv $1/$E/$E/* $1/$E
		rmdir $1/$E/$E
	fi
done

