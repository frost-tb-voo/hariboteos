#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../05_day/harib02i/Makefile {} \;" > Makefile_05.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib03a/Makefile {} \;" > Makefile_a.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib03b/Makefile {} \;" > Makefile_b.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib03d/Makefile {} \;" > Makefile_d.diff
echo 'find . -type d -name "harib0*" -exec cp harib03d/Makefile {} \;'
