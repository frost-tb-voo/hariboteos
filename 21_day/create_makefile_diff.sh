#!/bin/sh

LAST_DAY=20
LAST_CODE=17h
NEXT_CODE=18a
NEXT_CODE=18b
NEXT_CODE=18c
NEXT_CODE=18f

# # diff between 2 directories
# bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
# # diff in this directory
# bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff

echo overwrite all
echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'

LAST_DAY=21
LAST_CODE=18f
TODAY=21
NEXT_CODE=18g

echo confirm diff from root
echo 'diff -u ./'${LAST_DAY}'_day/harib'${LAST_CODE}' ./'${TODAY}'_day/harib'${NEXT_CODE}' > ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff'
echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "+++"'
echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "のみに存在"'
