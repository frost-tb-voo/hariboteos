#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../11_day/harib08h/Makefile {} \;" > Makefile_12.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib09a/Makefile {} \;" > Makefile_a.diff
echo 'find . -type d -name "harib0*" -exec cp harib09a/Makefile {} \;'
