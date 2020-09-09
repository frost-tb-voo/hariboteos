#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../09_day/harib06d/Makefile {} \;" > Makefile_09.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib07a/Makefile {} \;" > Makefile_a.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib07b/Makefile {} \;" > Makefile_b.diff
echo 'find . -type d -name "harib0*" -exec cp harib07a/Makefile {} \;'
