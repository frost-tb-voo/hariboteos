#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../07_day/harib04g/Makefile {} \;" > Makefile_07.diff
# bash -c "find . -name 'Makefile' -exec diff -u ./harib04a/Makefile {} \;" > Makefile_a.diff
echo 'find . -type d -name "harib0*" -exec cp harib05a/Makefile {} \;'
