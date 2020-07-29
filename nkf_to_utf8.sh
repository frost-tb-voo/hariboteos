#!/bin/sh

find . -type f -print0 | xargs -0 nkf -u --overwrite -w
#find . -type d -exec cp harib00a/Makefile {} \;

