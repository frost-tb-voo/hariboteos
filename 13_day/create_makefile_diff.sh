#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../12_day/harib09g/Makefile {} \;" > Makefile_13.diff
# bash -c "find . -name 'Makefile' -exec diff -u ./harib07a/Makefile {} \;" > Makefile_a.diff
echo 'find . -type d -name "harib0*" -exec cp harib10a/Makefile {} \;'
