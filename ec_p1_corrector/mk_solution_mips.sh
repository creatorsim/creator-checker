#!/bin/bash

#set -x

TEST_1=$(ls -1 test/ej1 | grep -v "\.o")
TEST_2=$(ls -1 test/ej2 | grep -v "\.o")

mkdir -p solution/test
mkdir -p solution/output

for T in $TEST_1; do
	echo $T

	#Generar salida de solución correcta
	cat solution/ejercicio1.s | grep -v ".text" > /tmp/$$.txt
	cat ./test/ej1/$T /tmp/$$.txt > solution/test/test_ejercicio1_$T
	./creator/creator.sh -a ./creator/architecture/MIPS-32.json -s solution/test/test_ejercicio1_$T -l test/ej1/apoyo.o -o min > solution/output/output_ejercicio1_$T.txt

	#Delete stack TODO if memory
	exits=$(grep "memory" solution/output/output_ejercicio1_$T.txt)

	if [ -n "${exits}" ]
	then
		mem=$(sed 's/.*memory\[\([^:]*\)\]:[^;]*;.*/\1/' solution/output/output_ejercicio1_$T.txt | tail -n 2 | sed ':a;N;$!ba;s/\n//g')
		
		if [ $(($mem)) -le $((0x0FFFFFFF)) ] && [ $(($mem)) -ge $((0x05BBFCBF)) ]
		then
			sed "s/memory\[$mem\][^;]*;\s//g" solution/output/output_ejercicio1_$T.txt > solution/output/aux_output_ejercicio1_$T.txt
		else
			cp solution/output/output_ejercicio1_$T.txt solution/output/aux_output_ejercicio1_$T.txt
		fi
	else 
		cp solution/output/output_ejercicio1_$T.txt solution/output/aux_output_ejercicio1_$T.txt
	fi

	#Delete registers, display and keyboard
	sed 's/cr[^;]*;\s//g' solution/output/aux_output_ejercicio1_$T.txt | \
	sed 's/ir\[t[0-9][^;]*;\s//g' | \
	sed 's/sfpr\[f[4-9][^;]*;\s//g' | \
	sed 's/sfpr\[f10[^;]*;\s//g' | \
	sed 's/dfpr[^;]*;\s//g' | \
	sed 's/sfpr\[f11[^;]*;\s//g' | \
	sed 's/ir\[ra[^;]*;\s//g' | \
	sed 's/keyboard[^;]*;\s//g' | \
	sed 's/display[^;]*;\s//g' | \
	sed 's/ir\[at[^;]*;\s//g' | \
	sed 's/ir\[fp[^;]*;\s//g' | \
	sed 's/ir\[a[0-3][^;]*;\s//g' > solution/output/output_ejercicio1_$T.txt 

	rm solution/output/aux_output_ejercicio1_$T.txt
done

for T in $TEST_2; do
	echo $T
	
	#Generar salida de solución correcta
	cat solution/ejercicio2.s | grep -v ".text" > /tmp/$$.txt
	cat ./test/ej2/$T /tmp/$$.txt > solution/test/test_ejercicio2_$T
	./creator/creator.sh -a ./creator/architecture/MIPS-32.json -s solution/test/test_ejercicio2_$T -o min > solution/output/output_ejercicio2_$T.txt

	#Delete stack TODO if memory
	exits=$(grep "memory" solution/output/output_ejercicio2_$T.txt)

	if [ -n "${exits}" ]
	then
		mem=$(sed 's/.*memory\[\([^:]*\)\]:[^;]*;.*/\1/' solution/output/output_ejercicio2_$T.txt | tail -n 2 | sed ':a;N;$!ba;s/\n//g')
		
		if [ $(($mem)) -le $((0x0FFFFFFF)) ] && [ $(($mem)) -ge $((0x05BBFCBF)) ]
		then
			sed "s/memory\[$mem\][^;]*;\s//g" solution/output/output_ejercicio2_$T.txt > solution/output/aux_output_ejercicio2_$T.txt
		else
			cp solution/output/output_ejercicio2_$T.txt solution/output/aux_output_ejercicio2_$T.txt
		fi
	else 
		cp solution/output/output_ejercicio2_$T.txt solution/output/aux_output_ejercicio2_$T.txt
	fi

	#Delete registers, display and keyboard
	sed 's/cr[^;]*;\s//g' solution/output/aux_output_ejercicio2_$T.txt | \
	sed 's/ir\[t[0-9][^;]*;\s//g' | \
	sed 's/sfpr\[f[4-9][^;]*;\s//g' | \
	sed 's/sfpr\[f10[^;]*;\s//g' | \
	sed 's/dfpr[^;]*;\s//g' | \
	sed 's/sfpr\[f11[^;]*;\s//g' | \
	sed 's/ir\[ra[^;]*;\s//g' | \
	sed 's/keyboard[^;]*;\s//g' | \
	sed 's/display[^;]*;\s//g' | \
	sed 's/ir\[at[^;]*;\s//g' | \
	sed 's/ir\[fp[^;]*;\s//g' | \
	sed 's/ir\[a[0-3][^;]*;\s//g' > solution/output/output_ejercicio2_$T.txt 

	rm solution/output/aux_output_ejercicio2_$T.txt
done
