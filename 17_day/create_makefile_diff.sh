#!/bin/sh

LAST_DAY=16
LAST_CODE=13e
NEXT_CODE=14a

# bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
# bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff
# echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
# echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'

LAST_DAY=17
LAST_CODE=14f
NEXT_CODE=14g

echo 'diff -u ./'${LAST_DAY}'_day/harib'${LAST_CODE}' ./17_day/harib'${NEXT_CODE}' > ./17_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff'
echo 'cat ./17_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "+++"'

