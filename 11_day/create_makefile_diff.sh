#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../10_day/harib07d/Makefile {} \;" > Makefile_10.diff
# bash -c "find . -name 'Makefile' -exec diff -u ./harib07a/Makefile {} \;" > Makefile_a.diff
echo 'find . -type d -name "harib0*" -exec cp harib08a/Makefile {} \;'
