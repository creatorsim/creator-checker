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
	./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s solution/test/test_ejercicio1_$T -l test/ej1/apoyo.o -o min > solution/output/output_ejercicio1_$T.txt

done

for T in $TEST_2; do
	echo $T
	
	#Generar salida de solución correcta
	cat solution/ejercicio2.s | grep -v ".text" > /tmp/$$.txt
	cat ./test/ej2/$T /tmp/$$.txt > solution/test/test_ejercicio2_$T
	./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s solution/test/test_ejercicio2_$T -o min > solution/output/output_ejercicio2_$T.txt

done
