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
GROUP=$1                                             # Group identification (e.g., gr-1, gr-2, etc.).
ENAME1=exercise                                      # Student assembly program file.
ARCH_PATH="/creator/architecture/RISCV/RV32IMFD.yml" # Architecture path for CREATOR.

TXTFILE="/workdir/submissions/${GROUP}/${GROUP}.txt"

# If the text file already exists, use it.
# Otherwise, create it from the current directory list.
if [ -f "$TXTFILE" ]; then
    echo "Using existing list: $TXTFILE"
else
    echo "Creating new list: $TXTFILE"
    ls -1 "/workdir/submissions/$GROUP" | sed 's/.zip$//' | grep -v index.html | sort | uniq > "$TXTFILE"
fi

# Read directories to process from the list file
LIST=$(cat "$TXTFILE" | tr -d '\r' | grep -v '^$')

TEST_1=$(ls -1 /workdir/tests/exercise_1 | grep -v "\.o") # TODO: generic

# Header
rm -fr /workdir/results/grades_$GROUP.csv
touch  /workdir/results/grades_$GROUP.csv

echo -n "Group;" >> /workdir/results/grades_$GROUP.csv

for T in $TEST_1; do
    echo -n $T";" >> /workdir/results/grades_$GROUP.csv
done

echo "" >> /workdir/results/grades_$GROUP.csv

#####
rm -fr            /workdir/submissions/$GROUP/index.html
touch             /workdir/submissions/$GROUP/index.html
echo "<html>" >>  /workdir/submissions/$GROUP/index.html
#####

# Grades
for E in $LIST; do

    echo " ### $E ###################### "
    echo -n $E";" >> /workdir/results/grades_$GROUP.csv

    rm -fr /workdir/submissions/$GROUP/$E/test
    rm -fr /workdir/submissions/$GROUP/$E/test_output
    rm -fr /workdir/submissions/$GROUP/$E/test_problems
    rm -fr /workdir/submissions/$GROUP/$E/logs.txt

    mkdir -p /workdir/submissions/$GROUP/$E/test
    mkdir -p /workdir/submissions/$GROUP/$E/test_output

    #######
    echo "<table>"           >> /workdir/submissions/$GROUP/index.html
    echo "<tr>"              >> /workdir/submissions/$GROUP/index.html
    echo "<td>Group</td>"    >> /workdir/submissions/$GROUP/index.html
    echo "<td>Test</td>"     >> /workdir/submissions/$GROUP/index.html
    echo "<td>OK</td>"       >> /workdir/submissions/$GROUP/index.html
    echo "<td>Output</td>"   >> /workdir/submissions/$GROUP/index.html
    echo "<td>Src</td>"      >> /workdir/submissions/$GROUP/index.html
    echo "</tr>"             >> /workdir/submissions/$GROUP/index.html
    #######

    for T in $TEST_1; do

        echo -n $T" "

        # Build test code
        cat /workdir/submissions/$GROUP/$E/${ENAME1}.s | \
        sed 's/\.text/ /gi'     | \
        sed 's/\.data/ /gi'     | \
        sed 's/\bmain:/main_student:/gi' > /tmp/$$.txt

        cat ./test/exercise_1/$T /tmp/$$.txt  >  /workdir/submissions/$GROUP/$E/test/test_${ENAME1}_$T # TODO: generic









        # CREATOR...
        /creator/creator.sh -a $ARCH_PATH -s /workdir/submissions/$GROUP/$E/test/test_${ENAME1}_$T --validate /workdir/tests/solution/output_${ENAME1}_$T.yml > /tmp/$$.txt

        if [ $? -eq 0 ]
        then
           echo -n "1;" >> /workdir/results/grades_$GROUP.csv
           OK=1
        else
           echo -n "0;" >> /workdir/results/grades_$GROUP.csv
           OK=0

            mkdir -p /workdir/submissions/$GROUP/$E/test_problems

            /creator/creator.sh -a $ARCH_PATH -s /workdir/submissions/$GROUP/$E/test/test_${ENAME1}_$T --validate /workdir/tests/solution/output_${ENAME1}_$T.yml &> /workdir/submissions/$GROUP/$E/test_problems/problem_${ENAME1}_$T.txt

            #/creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s /workdir/submissions/$GROUP/$E/test/test_${ENAME1}_$T | aha > /workdir/submissions/$GROUP/$E/test_problems/problem_${ENAME1}_$T.html
            #wkhtmltopdf /workdir/submissions/$GROUP/$E/test_problems/problem_${ENAME1}_$T.html /workdir/submissions/$GROUP/$E/test_problems/problem_${ENAME1}_$T.pdf &> /dev/null
        fi

        cp /workdir/submissions/$GROUP/$E/test/test_${ENAME1}_$T /workdir/submissions/$GROUP/$E/test_output/e1_$T.txt
        cp /tmp/$$.txt                                           /workdir/submissions/$GROUP/$E/test_output/s1_$T.txt

        cat /tmp/$$.txt >> /workdir/submissions/$GROUP/$E/logs.txt
        cat /tmp/$$.txt
        rm  /tmp/$$.txt




        #######
        echo ""                                                             >> /workdir/submissions/$GROUP/index.html
        echo "<tr>"                                                         >> /workdir/submissions/$GROUP/index.html
        echo "<td>$E</td>"                                                  >> /workdir/submissions/$GROUP/index.html
        echo "<td>$T</td>"                                                  >> /workdir/submissions/$GROUP/index.html
        echo "<td>$OK</td>"                                                 >> /workdir/submissions/$GROUP/index.html
        echo "<td><a href=\"./$E/test_output/s1_$T.txt\">link</a></td>"     >> /workdir/submissions/$GROUP/index.html
        echo "<td><a href=\"./$E/test_output/e1_$T.txt\">link</a></td>"     >> /workdir/submissions/$GROUP/index.html
        echo "</tr>"                                                        >> /workdir/submissions/$GROUP/index.html
        #######
    done


    #######
    echo "<tr>"              >> /workdir/submissions/$GROUP/index.html
    echo "<td>Group</td>"    >> /workdir/submissions/$GROUP/index.html
    echo "<td>Test</td>"     >> /workdir/submissions/$GROUP/index.html
    echo "<td>OK</td>"       >> /workdir/submissions/$GROUP/index.html
    echo "<td>Output</td>"   >> /workdir/submissions/$GROUP/index.html
    echo "<td>Src</td>"      >> /workdir/submissions/$GROUP/index.html
    echo "</tr>"             >> /workdir/submissions/$GROUP/index.html
    #######


    #######
    echo "</table>"        >> /workdir/submissions/$GROUP/index.html
    echo "</html>"         >> /workdir/submissions/$GROUP/index.html
    #######

    echo ""
    echo ""
    echo "" >> /workdir/results/grades_$GROUP.csv
done