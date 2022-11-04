#!/bin/bash

#Compiler
C="gcc -lm"

#The color code
red='\033[0;31m'
RED='\033[1;31m'
GREEN='\033[1;32m'
green='\033[0;32m'
blue='\033[0;34m'
BLUE='\033[1;34m'
cyan='\033[0;36m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

#No input argument case.
if [ "$#" -ne 1 ]; then
 echo -e "${RED}No parameters, please try again.${NC}"
 exit 1
fi

#declare time constant
TL=1

#Into the student folder.
cd 20221031/$1

tmp="tmp"

#Print student information...
echo
echo "Student ID : $1"
echo
echo

#The time for problem.
for ((i=1;i<=6;i++))
do  
    #print message...
    echo -e "---------Problem $i start judging---------"
    echo

    #Find the program file, if it doesn't exit, continue to test next problem.
    target_program_file="$1_P$i.c"
    if [ ! -e $target_program_file ]
    then
        echo -e "${RED}$target_program_file doesn't exist.${NC}"
        echo
        echo "-----------------------------------------"
        echo
        echo 
        continue
    fi

    COMPILER="$C $target_program_file 2> .compiler_report"

    echo "$COMPILER" | sh
    echo "Compiling..."
    #compile, if it run into error, continue to test next problem.
    if [ $? -ne 0 ]
    then
        echo -e "${RED}Compilation Error${NC}";
        echo
        echo "-----------------------------------------"
        echo 
        echo
        continue
    fi

    echo -e "${GREEN}Compile: OK${NC}";
    echo

    ulimit -t $TL;

    score=0
    MAX_IN=50

    for ((j=1;j<=$MAX_IN;j++))
    do
        TEST_CASE_IN="../../P$i/input$j.txt"
        TEST_CASE_OUT="../../P$i/output$j.txt"

        # If i-th test case doesn't exist then stop here.
        if [ ! -e $TEST_CASE_IN ]
        then
            break
        fi
        #start judging
        echo -e "${BLUE}Test case $j :${NC}\c";

        ./a.out < $TEST_CASE_IN > .$tmp.out
        
        #cat .$1.out
        diff -w .$tmp.out $TEST_CASE_OUT > /dev/null
        if [ $? -eq 0 ]
        then
            echo -e "  ${GREEN}Accept${NC}"
            score=$(($score+2))
        else
            echo -e "  ${RED}Wrong Answer${NC}"
        fi
    done
    #clean all file
    rm -f .overview .compiler_report .time_info .$tmp.out a.out
    trap "{ rm -f .overview .compiler_report .time_info .$tmp.out a.out; }" SIGINT SIGTERM EXIT
    echo
    echo -e "Problem $i gets score $score"
    echo "-----------------------------------------"
    echo
    echo
done




    



