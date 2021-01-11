#!/bin/sh

LAST_DAY=19
LAST_CODE=16e
TODAY=20
NEXT_CODE=17a
NEXT_CODE=17f

# diff between 2 directories
bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
# diff in this directory
bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff

echo overwrite all
echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'

echo confirm diff from root
echo 'diff -u ./'${LAST_DAY}'_day/harib'${LAST_CODE}' ./'${TODAY}'_day/harib'${NEXT_CODE}' > ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff'
echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "+++"'

