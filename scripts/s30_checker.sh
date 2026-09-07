#!/bin/bash
#set -x

# check arguments
if [ "$#" -lt 1 ];
then
    echo ""
    echo " CREATOR checker"
    echo "  Usage: ./s30_checker.sh <reduced group>"
    echo ""
    exit -1
fi

# set initial values
GROUP=$1
ENAME1=exercises

#ls -1 $GROUP > $GROUP.txt

#LIST=$(cat $GROUP.txt | sed 's/.zip//g' | grep -v index.html | sort | uniq)
TXTFILE="${GROUP}.txt"

# If the text file already exists, use it.
# Otherwise, create it from the current directory list.
if [ -f "$TXTFILE" ]; then
    echo "Using existing list: $TXTFILE"
else
    echo "Creating new list: $TXTFILE"
    ls -1 "$GROUP" | sed 's/.zip$//' | grep -v index.html | sort | uniq > "$TXTFILE"
fi

# Read directories to process from the list file
LIST=$(cat "$TXTFILE" | tr -d '\r' | grep -v '^$')

#exit 0
TEST_1=$(ls -1 test/ej1 | grep -v "\.o")
TEST_2=$(ls -1 test/ej2 | grep -v "\.o")
TEST_3=$(ls -1 test/ej3 | grep -v "\.o")

# Header
rm -fr Notas_$GROUP.csv
touch  Notas_$GROUP.csv

echo -n "Group;" >> Notas_$GROUP.csv
for T in $TEST_1; do
    echo -n $T";" >> Notas_$GROUP.csv
done

for T in $TEST_2; do
    echo -n $T";" >> Notas_$GROUP.csv
done
#echo "" >> Notas_$GROUP.csv

for T in $TEST_3; do
    echo -n $T";" >> Notas_$GROUP.csv
done
echo "" >> Notas_$GROUP.csv

#####
rm -fr            $GROUP/index.html
touch             $GROUP/index.html
echo "<html>" >>  $GROUP/index.html
#####

# Grades
for E in $LIST; do

    echo " ### $E ###################### "
    echo -n $E";" >> Notas_$GROUP.csv

    rm -fr $GROUP/$E/test
    rm -fr $GROUP/$E/test_problems
    rm -fr $GROUP/$E/logs.txt

    mkdir -p $GROUP/$E/test

    #######
    echo "<table>"           >> $GROUP/index.html
    echo "<tr>"              >> $GROUP/index.html
    echo "<td>Group</td>"    >> $GROUP/index.html
    echo "<td>Test</td>"     >> $GROUP/index.html
    echo "<td>OK</td>"       >> $GROUP/index.html
    echo "<td>Output</td>"   >> $GROUP/index.html
    echo "<td>Src</td>"      >> $GROUP/index.html
    echo "</tr>"             >> $GROUP/index.html

    rm   -fr          $GROUP/$E/test_output
    mkdir -p          $GROUP/$E/test_output
    #######

    for T in $TEST_1; do

        echo -n $T" "

        # Build test code
        cat $GROUP/$E/${ENAME1}.s | \
        sed 's/\.text/ /gi'     | \
        sed 's/\.data/ /gi'     | \
        sed 's/\bmain:/main_student:/gi' > /tmp/$$.txt

        cat ./test/ej1/$T /tmp/$$.txt  >  $GROUP/$E/test/test_${ENAME1}_$T

        # creator...
        /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o -o min -r solution/output/output_${ENAME1}_$T.txt --maxins 100000 > /tmp/$$.txt

        if [ $? -eq 0 ]
        then
           echo -n "1;" >> Notas_$GROUP.csv
           OK=1
        else
           echo -n "0;" >> Notas_$GROUP.csv
           OK=0

            mkdir -p $GROUP/$E/test_problems
            /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o --maxins 100000 &> $GROUP/$E/test_problems/problem_${ENAME1}_$T.txt

            #/creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T | aha > $GROUP/$E/test_problems/problem_${ENAME1}_$T.html
            #wkhtmltopdf $GROUP/$E/test_problems/problem_${ENAME1}_$T.html $GROUP/$E/test_problems/problem_${ENAME1}_$T.pdf &> /dev/null
        fi

        #######
        echo ""                                                             >> $GROUP/index.html
        echo "<tr>"                                                         >> $GROUP/index.html
        echo "<td>$E</td>"                                                  >> $GROUP/index.html
        echo "<td>$T</td>"                                                  >> $GROUP/index.html
        echo "<td>$OK</td>"                                                 >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/s1_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/e1_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "</tr>"                                                        >> $GROUP/index.html

        cp $GROUP/$E/test/test_${ENAME1}_$T   $GROUP/$E/test_output/e1_$T.txt
        cp /tmp/$$.txt                        $GROUP/$E/test_output/s1_$T.txt
        #######

        cat /tmp/$$.txt >> $GROUP/$E/logs.txt
        cat /tmp/$$.txt
        rm  /tmp/$$.txt
    done


    #######
    echo "<tr>"              >> $GROUP/index.html
    echo "<td>Group</td>"    >> $GROUP/index.html
    echo "<td>Test</td>"     >> $GROUP/index.html
    echo "<td>OK</td>"       >> $GROUP/index.html
    echo "<td>Output</td>"   >> $GROUP/index.html
    echo "<td>Src</td>"      >> $GROUP/index.html
    echo "</tr>"             >> $GROUP/index.html
    #######

    for T in $TEST_2; do

        echo -n $T" "

        # Build test code
        cat $GROUP/$E/${ENAME1}.s | \
        sed 's/\.text/ /gi'     | \
        sed 's/\.data/ /gi'     | \
        sed 's/\bmain:/main_student:/gi' > /tmp/$$.txt

        cat ./test/ej2/$T /tmp/$$.txt  >  $GROUP/$E/test/test_${ENAME1}_$T

        # creator...
        /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o -o min -r solution/output/output_${ENAME1}_$T.txt --maxins 1000000 > /tmp/$$.txt

        if [ $? -eq 0 ]
        then
           echo -n "1;" >> Notas_$GROUP.csv
           OK=1
        else
           echo -n "0;" >> Notas_$GROUP.csv
           OK=0

            mkdir -p $GROUP/$E/test_problems
            /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o --maxins 1000000 &> $GROUP/$E/test_problems/problem_${ENAME1}_$T.txt

            #/creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T | aha > $GROUP/$E/test_problems/problem_${ENAME1}_$T.html
            #wkhtmltopdf $GROUP/$E/test_problems/problem_${ENAME1}_$T.html $GROUP/$E/test_problems/problem_${ENAME1}_$T.pdf &> /dev/null
        fi

        #######
        echo ""                                                             >> $GROUP/index.html
        echo "<tr>"                                                         >> $GROUP/index.html
        echo "<td>$E</td>"                                                  >> $GROUP/index.html
        echo "<td>$T</td>"                                                  >> $GROUP/index.html
        echo "<td>$OK</td>"                                                 >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/s2_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/e2_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "</tr>"                                                        >> $GROUP/index.html

        cp $GROUP/$E/test/test_${ENAME1}_$T   $GROUP/$E/test_output/e2_$T.txt
        cp /tmp/$$.txt                        $GROUP/$E/test_output/s2_$T.txt
        #######

        cat /tmp/$$.txt >> $GROUP/$E/logs.txt
        cat /tmp/$$.txt
        rm  /tmp/$$.txt
    done


    #######
    echo "<tr>"              >> $GROUP/index.html
    echo "<td>Group</td>"    >> $GROUP/index.html
    echo "<td>Test</td>"     >> $GROUP/index.html
    echo "<td>OK</td>"       >> $GROUP/index.html
    echo "<td>Output</td>"   >> $GROUP/index.html
    echo "<td>Src</td>"      >> $GROUP/index.html
    echo "</tr>"             >> $GROUP/index.html
    #######

    for T in $TEST_3; do

        echo -n $T" "

        #Comparar con solucion correcta
        cat $GROUP/$E/${ENAME1}.s | \
        sed 's/\.text/ /gi' | \
        sed 's/\.data/ /gi' | \
        sed 's/\bmain:/main_student:/gi' | \
        sed 's/\bNewton_real:/Newton_real_student:/gi' > /tmp/$$.txt

        cat ./test/ej3/$T /tmp/$$.txt > $GROUP/$E/test/test_${ENAME1}_$T


        /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o -o min -r solution/output/output_${ENAME1}_$T.txt --maxins 100000 > /tmp/$$.txt

        if [ $? -eq 0 ]
        then
                echo -n "1;" >> Notas_$GROUP.csv
        else
            echo -n "0;" >> Notas_$GROUP.csv

            mkdir -p $GROUP/$E/test_problems
            /creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T -l test/pow.o --maxins 100000 &> $GROUP/$E/test_problems/problem_${ENAME1}_$T.txt

            #/creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s $GROUP/$E/test/test_${ENAME1}_$T | aha > $GROUP/$E/test_problems/problem_${ENAME1}_$T.html
            #wkhtmltopdf $GROUP/$E/test_problems/problem_${ENAME1}_$T.html $GROUP/$E/test_problems/problem_${ENAME1}_$T.pdf &> /dev/null
        fi

        #######
        echo ""                                                             >> $GROUP/index.html
        echo "<tr>"                                                         >> $GROUP/index.html
        echo "<td>$E</td>"                                                  >> $GROUP/index.html
        echo "<td>$T</td>"                                                  >> $GROUP/index.html
        echo "<td>$OK</td>"                                                 >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/s3_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "<td><a href=\"./$E/test_output/e3_$T.txt\">link</a></td>"     >> $GROUP/index.html
        echo "</tr>"                                                        >> $GROUP/index.html

        cp $GROUP/$E/test/test_${ENAME1}_$T   $GROUP/$E/test_output/e3_$T.txt
        cp /tmp/$$.txt                        $GROUP/$E/test_output/s3_$T.txt
        #######

        cat /tmp/$$.txt >> $GROUP/$E/logs.txt
        cat /tmp/$$.txt
        rm  /tmp/$$.txt
    done

    #######
    echo "</table>"        >> $GROUP/index.html
    echo "</html>"         >> $GROUP/index.html
    #######

    echo ""
    echo ""
    echo "" >> Notas_$GROUP.csv
done

#rm $GROUP.txt

