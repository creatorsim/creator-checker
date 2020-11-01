#!/bin/bash

#set -x

if [ "$#" -lt 1 ];
then
    echo "Error. Not enough arguments.\n"
    echo "./corrector <group>"
    exit -1
fi

GROUP=$1

ls -1 $GROUP > $GROUP.txt

LIST=$(cat $GROUP.txt | sed 's/.zip//g' | sort | uniq)
TEST_1=$(ls -1 test/ej1 | grep -v "\.o")
TEST_2=$(ls -1 test/ej2 | grep -v "\.o")

rm -fr Notas_$GROUP.csv
touch Notas_$GROUP.csv

#Header
echo -n "Group;" >> Notas_$GROUP.csv
for T in $TEST_1; do
	echo -n $T";" >> Notas_$GROUP.csv
done

for T in $TEST_2; do
	echo -n $T";" >> Notas_$GROUP.csv
done
echo "" >> Notas_$GROUP.csv

#Grades
for E in $LIST; do
	echo $E
	echo -n $E";" >> Notas_$GROUP.csv

	mkdir -p $GROUP/$E/test

	for T in $TEST_1; do
		echo -n $T" "

		#Comparar con solucion correcta
		cat $GROUP/$E/ejercicio1.s | grep -v ".text" > /tmp/$$.txt
		cat ./test/ej1/$T /tmp/$$.txt > $GROUP/$E/test/test_ejercicio1_$T
		./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio1_$T -l test/ej1/apoyo.o -o min -r solution/output/output_ejercicio1_$T.txt

		if [ $? -eq 0 ]
		then
		   echo -n "1;" >> Notas_$GROUP.csv
		else
			echo -n "0;" >> Notas_$GROUP.csv

			mkdir -p $GROUP/$E/test_problems
			./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio1_$T -l test/ej1/apoyo.o &> $GROUP/$E/test_problems/problem_ejercicio1_$T.txt

			#./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio1_$T -l test/ej1/apoyo.o | aha > $GROUP/$E/test_problems/problem_ejercicio1_$T.html
			#wkhtmltopdf $GROUP/$E/test_problems/problem_ejercicio1_$T.html $GROUP/$E/test_problems/problem_ejercicio1_$T.pdf &> /dev/null
		fi
	done

	for T in $TEST_2; do
		echo -n $T" "

		#Comparar con solucion correcta
		cat $GROUP/$E/ejercicio2.s | grep -v ".text" > /tmp/$$.txt
		cat ./test/ej2/$T /tmp/$$.txt > $GROUP/$E/test/test_ejercicio2_$T
		./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio2_$T -o min -r solution/output/output_ejercicio2_$T.txt

		if [ $? -eq 0 ]
		then
		   echo -n "1;" >> Notas_$GROUP.csv
		else
			echo -n "0;" >> Notas_$GROUP.csv

			mkdir -p $GROUP/$E/test_problems
			./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio2_$T -l test/ej2/apoyo.o &> $GROUP/$E/test_problems/problem_ejercicio2_$T.html

			#./creator/creator.sh -a ./creator/architecture/MIPS-32-like.json -s $GROUP/$E/test/test_ejercicio1_$T -l test/ej1/apoyo.o | aha > $GROUP/$E/test_problems/problem_ejercicio1_$T.html
			#wkhtmltopdf $GROUP/$E/test_problems/problem_ejercicio1_$T.html $GROUP/$E/test_problems/problem_ejercicio1_$T.pdf &> /dev/null
		fi
	done
	echo ""
	echo ""
	echo "" >> Notas_$GROUP.csv
done

rm $GROUP.txt