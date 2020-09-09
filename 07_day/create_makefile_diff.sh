#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../06_day/harib03e/Makefile {} \;" > Makefile_06.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib04a/Makefile {} \;" > Makefile_a.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib04e/Makefile {} \;" > Makefile_e.diff
echo 'find . -type d -name "harib0*" -exec cp harib04g/Makefile {} \;'
