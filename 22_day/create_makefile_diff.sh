#!/bin/sh

# diff for Makefile
LAST_DAY=21
LAST_CODE=18g
NEXT_CODE=19a
NEXT_CODE=19b
NEXT_CODE=19c
NEXT_CODE=19d
NEXT_CODE=19e
NEXT_CODE=19f

# diff between 2 directories
bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
# diff in this directory
bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff

# overwrite all Makefiles
echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'


# diff for all
LAST_DAY=22
LAST_CODE=19a
TODAY=22
NEXT_CODE=19b

# echo diff from root
# echo 'diff -u ./'${LAST_DAY}'_day/harib'${LAST_CODE}' ./'${TODAY}'_day/harib'${NEXT_CODE}' > ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff'
# echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "+++"'
# echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "のみに存在"'
