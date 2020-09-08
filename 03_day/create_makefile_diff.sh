#!/bin/sh

bash -c "find . -name 'Makefile' -exec diff -u ../02_day/helloos5/Makefile {} \;" > Makefile_02.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib00a_01/Makefile {} \;" > Makefile_a.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib00e_05/Makefile {} \;" > Makefile_e.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib00g_07/Makefile {} \;" > Makefile_g.diff
bash -c "find . -name 'Makefile' -exec diff -u ./harib00i_09/Makefile {} \;" > Makefile_i.diff
echo 'find . -type d -name "harib0*" -exec cp harib00a_01/Makefile {} \;'
