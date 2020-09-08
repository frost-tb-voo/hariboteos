#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../08_day/harib05d/Makefile {} \;" > Makefile_08.diff
# bash -c "find . -name 'Makefile' -exec diff -u ./harib04a/Makefile {} \;" > Makefile_a.diff
echo 'find . -type d -name "harib0*" -exec cp harib06a/Makefile {} \;'
