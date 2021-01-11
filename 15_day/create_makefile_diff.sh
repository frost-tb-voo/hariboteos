#!/bin/sh

LAST_DAY=14
LAST_CODE=11i
NEXT_CODE=12a

bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff
echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'
