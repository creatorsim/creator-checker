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
    ls -1 "/workdir/submissions/$GROUP" | sed 's/.zip$//' | grep -v index_$GROUP.html | sort | uniq > "$TXTFILE"
fi

# Read directories to process from the list file
LIST=$(cat "$TXTFILE" | tr -d '\r' | grep -v '^$')

TEST_1=$(ls -1 /workdir/tests/exercise_1 | grep -v "\.o") # TODO: generic

# Header
rm    -rf /workdir/results/$GROUP
mkdir -p  /workdir/results/$GROUP
touch     /workdir/results/$GROUP/grades_$GROUP.csv
#####
touch             /workdir/results/$GROUP/index_$GROUP.html
echo "<html>" >>  /workdir/results/$GROUP/index_$GROUP.html
#####


echo -n "Group;" >> /workdir/results/$GROUP/grades_$GROUP.csv

for T in $TEST_1; do
    echo -n $T";" >> /workdir/results/$GROUP/grades_$GROUP.csv
done

echo "" >> /workdir/results/$GROUP/grades_$GROUP.csv


# Grades
for E in $LIST; do

    echo " ### $E ###################### "
    echo -n $E";" >> /workdir/results/$GROUP/grades_$GROUP.csv

    mkdir -p /workdir/results/$GROUP/$E
    mkdir -p /workdir/results/$GROUP/$E/test
    mkdir -p /workdir/results/$GROUP/$E/test_output
    #######
    echo "<table>"           >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<tr>"              >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Group</td>"    >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Test</td>"     >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>OK</td>"       >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Output</td>"   >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Src</td>"      >> /workdir/results/$GROUP/index_$GROUP.html
    echo "</tr>"             >> /workdir/results/$GROUP/index_$GROUP.html
    #######

    for T in $TEST_1; do

        echo -n $T" "

        # Build test code
        cat /workdir/results/$GROUP/$E/${ENAME1}.s | \
        sed 's/\.text/ /gi'     | \
        sed 's/\.data/ /gi'     | \
        sed 's/\bmain:/main_student:/gi' > /tmp/$$.txt

        cat ./test/exercise_1/$T /tmp/$$.txt  >  /workdir/results/$GROUP/$E/test/test_${ENAME1}_$T # TODO: generic









        # CREATOR...
        # /creator/creator.sh -a $ARCH_PATH -s /workdir/results/$GROUP/$E/test/test_${ENAME1}_$T --validate /workdir/tests/solution/output_${ENAME1}_$T.yml > /tmp/$$.txt

        # if [ $? -eq 0 ]
        # then
        #    echo -n "1;" >> /workdir/results/$GROUP/grades_$GROUP.csv
        #    OK=1
        # else
        #    echo -n "0;" >> /workdir/results/$GROUP/grades_$GROUP.csv
        #    OK=0

        #     mkdir -p /workdir/results/$GROUP/$E/test_problems

        #     /creator/creator.sh -a $ARCH_PATH -s /workdir/results/$GROUP/$E/test/test_${ENAME1}_$T --validate /workdir/tests/solution/output_${ENAME1}_$T.yml &> /workdir/results/$GROUP/$E/test_problems/problem_${ENAME1}_$T.txt

            #/creator/creator.sh -a "/creator/architecture/RISC_V_RV32IMFD.json" -s /workdir/results/$GROUP/$E/test/test_${ENAME1}_$T | aha > /workdir/results/$GROUP/$E/test_problems/problem_${ENAME1}_$T.html
            #wkhtmltopdf /workdir/results/$GROUP/$E/test_problems/problem_${ENAME1}_$T.html /workdir/results/$GROUP/$E/test_problems/problem_${ENAME1}_$T.pdf &> /dev/null
        # fi






        cp /workdir/results/$GROUP/$E/test/test_${ENAME1}_$T /workdir/results/$GROUP/$E/test_output/e1_$T.txt
        cp /tmp/$$.txt                                       /workdir/results/$GROUP/$E/test_output/s1_$T.txt

        cat /tmp/$$.txt >> /workdir/results/$GROUP/$E/logs.txt
        cat /tmp/$$.txt
        rm  /tmp/$$.txt




        #######
        echo ""                                                             >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<tr>"                                                         >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<td>$E</td>"                                                  >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<td>$T</td>"                                                  >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<td>$OK</td>"                                                 >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<td><a href=\"./$E/test_output/s1_$T.txt\">link</a></td>"     >> /workdir/results/$GROUP/index_$GROUP.html
        echo "<td><a href=\"./$E/test_output/e1_$T.txt\">link</a></td>"     >> /workdir/results/$GROUP/index_$GROUP.html
        echo "</tr>"                                                        >> /workdir/results/$GROUP/index_$GROUP.html
        #######
    done


    #######
    echo "<tr>"              >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Group</td>"    >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Test</td>"     >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>OK</td>"       >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Output</td>"   >> /workdir/results/$GROUP/index_$GROUP.html
    echo "<td>Src</td>"      >> /workdir/results/$GROUP/index_$GROUP.html
    echo "</tr>"             >> /workdir/results/$GROUP/index_$GROUP.html
    #######


    #######
    echo "</table>"        >> /workdir/results/$GROUP/index_$GROUP.html
    echo "</html>"         >> /workdir/results/$GROUP/index_$GROUP.html
    #######

    echo ""
    echo ""
    echo "" >> /workdir/results/$GROUP/grades_$GROUP.csv
done