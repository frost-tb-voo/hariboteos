#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ./harib02a/Makefile {} \;" > Makefile.diff
#find . -type d -exec cp harib00a/Makefile {} \;

