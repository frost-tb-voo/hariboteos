#!/bin/sh

# diff for Makefile
LAST_DAY=22
LAST_CODE=19g
NEXT_CODE=20a
NEXT_CODE=20b
NEXT_CODE=20c
NEXT_CODE=20d
NEXT_CODE=20f

# diff between 2 directories
bash -c "find . -name 'Makefile' -exec diff -u ../${LAST_DAY}_day/harib${LAST_CODE}/Makefile {} \;" > Makefile_${LAST_DAY}.diff
# diff in this directory
bash -c "find . -name 'Makefile' -exec diff -u ./harib${NEXT_CODE}/Makefile {} \;" > Makefile_${NEXT_CODE}.diff

# overwrite all Makefiles
echo 'cp ../'${LAST_DAY}'_day/harib'${LAST_CODE}'/Makefile ./harib'${NEXT_CODE}'/'
echo 'find . -type d -name "harib*" -exec cp ./harib'${NEXT_CODE}'/Makefile {} \;'


# diff for all
LAST_DAY=23
LAST_CODE=20a
TODAY=23
NEXT_CODE=20b

# echo diff from root
# echo 'diff -u ./'${LAST_DAY}'_day/harib'${LAST_CODE}' ./'${TODAY}'_day/harib'${NEXT_CODE}' > ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff'
# echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "+++"'
# echo 'cat ./'${TODAY}'_day/harib'${LAST_CODE}'_'${NEXT_CODE}'.diff | grep "のみに存在"'
