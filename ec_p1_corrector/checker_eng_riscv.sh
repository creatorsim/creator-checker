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
TEST_3=$(ls -1 test/ej3 | grep -v "\.o")

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

for T in $TEST_3; do
	echo -n $T";" >> Notas_$GROUP.csv
done
echo "" >> Notas_$GROUP.csv

#Grades
for E in $LIST; do
	echo $E
	echo -n $E";" >> Notas_$GROUP.csv

	rm -fr $GROUP/$E/test
	rm -fr $GROUP/$E/test_problems
	rm -fr $GROUP/$E/logs.txt

	mkdir -p $GROUP/$E/test

	for T in $TEST_1; do
		echo -n $T" "

		#Comparar con solucion correcta
		cat $GROUP/$E/exercise1.s | \
		sed 's/\.text/ /gi' | \
		sed 's/\.data/ /gi' | \
		sed 's/main/main_student/gi' > /tmp/$$.txt

		cat ./test/ej1/$T /tmp/$$.txt > $GROUP/$E/test/test_exercise1_$T


		./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise1_$T -o min -r solution/output/output_ejercicio1_$T.txt --maxins 50000 > /tmp/$$.txt
		
		if [ $? -eq 0 ]
		then
		   echo -n "1;" >> Notas_$GROUP.csv
		else
			echo -n "0;" >> Notas_$GROUP.csv

			mkdir -p $GROUP/$E/test_problems
			./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise1_$T --maxins 50000 &> $GROUP/$E/test_problems/problem_exercise1_$T.txt

			#./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise1_$T | aha > $GROUP/$E/test_problems/problem_exercise1_$T.html
			#wkhtmltopdf $GROUP/$E/test_problems/problem_exercise1_$T.html $GROUP/$E/test_problems/problem_exercise1_$T.pdf &> /dev/null
		fi

		cat /tmp/$$.txt >> $GROUP/$E/logs.txt
		cat /tmp/$$.txt
		rm /tmp/$$.txt
	done


	cat solution/ejercicio1.s | \
	sed 's/.text/ /gi' > /tmp/ej1_teacher.txt

	for T in $TEST_2; do
		echo -n $T" "

		#Comparar con solucion correcta
		cat $GROUP/$E/exercise2.s | \
		sed 's/\.text/ /gi' | \
		sed 's/\.data/ /gi' | \
		sed 's/main/main_student/gi' | \
		sed 's/string_compare:/string_compare_student:/gi' > /tmp/$$.txt

		cat ./test/ej2/$T /tmp/$$.txt /tmp/ej1_teacher.txt > $GROUP/$E/test/test_exercise2_$T

		./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise2_$T -o min -r solution/output/output_ejercicio2_$T.txt --maxins 50000 > /tmp/$$.txt

		if [ $? -eq 0 ]
		then
		   	./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise2_$T --maxins 50000 &> /tmp/display_$$.txt

		   	MAX=$(cat /tmp/display_$$.txt | grep "^[0-9]" | sort | tail -1)
		   	ELTO=$(cat /tmp/display_$$.txt | grep "^[0-9]" | sort | tail -2 | head -1)

		   	if [ $MAX -gt $ELTO ];
		   	then
		   		echo -n "1;" >> Notas_$GROUP.csv
		   	else
		   		echo -n "0;" >> Notas_$GROUP.csv

		   		mkdir -p $GROUP/$E/test_problems

				./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise2_$T --maxins 50000 &> $GROUP/$E/test_problems/problem_exercise2_$T.txt

				#./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_ejercicio1_$T | aha > $GROUP/$E/test_problems/problem_ejercicio1_$T.html
				#wkhtmltopdf $GROUP/$E/test_problems/problem_ejercicio1_$T.html $GROUP/$E/test_problems/problem_ejercicio1_$T.pdf &> /dev/null
		   	fi
		else
			echo -n "0;" >> Notas_$GROUP.csv

			mkdir -p $GROUP/$E/test_problems

			./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise2_$T --maxins 50000 &> $GROUP/$E/test_problems/problem_exercise2_$T.txt

			#./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_ejercicio1_$T | aha > $GROUP/$E/test_problems/problem_ejercicio1_$T.html
			#wkhtmltopdf $GROUP/$E/test_problems/problem_ejercicio1_$T.html $GROUP/$E/test_problems/problem_ejercicio1_$T.pdf &> /dev/null
		fi

		cat /tmp/$$.txt >> $GROUP/$E/logs.txt
		cat /tmp/$$.txt
		rm /tmp/display_$$.txt
		rm /tmp/$$.txt
	done

	for T in $TEST_3; do
		echo -n $T" "

		#Comparar con solucion correcta
		cat $GROUP/$E/exercise3.s | \
		sed 's/\.text/ /gi' | \
		sed 's/\.data/ /gi' | \
		sed 's/main/main_student/gi'  | \
		sed 's/string_compare:/string_compare_student:/gi' > /tmp/$$.txt

		cat ./test/ej3/$T /tmp/$$.txt /tmp/ej1_teacher.txt > $GROUP/$E/test/test_exercise3_$T


		./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise3_$T -o min -r solution/output/output_ejercicio3_$T.txt --maxins 50000 > /tmp/$$.txt

		if [ $? -eq 0 ]
		then
		   echo -n "1;" >> Notas_$GROUP.csv
		else
			echo -n "0;" >> Notas_$GROUP.csv

			mkdir -p $GROUP/$E/test_problems
			./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise3_$T --maxins 50000 &> $GROUP/$E/test_problems/problem_exercise3_$T.txt

			#./creator/creator.sh -a "./creator/architecture/RISC-V (RV32IMFD).json" -s $GROUP/$E/test/test_exercise1_$T | aha > $GROUP/$E/test_problems/problem_exercise1_$T.html
			#wkhtmltopdf $GROUP/$E/test_problems/problem_exercise1_$T.html $GROUP/$E/test_problems/problem_exercise1_$T.pdf &> /dev/null
		fi

		cat /tmp/$$.txt >> $GROUP/$E/logs.txt
		cat /tmp/$$.txt
		rm /tmp/$$.txt
	done

	rm /tmp/ej1_teacher.txt
	echo ""
	echo ""
	echo "" >> Notas_$GROUP.csv
done

rm $GROUP.txt