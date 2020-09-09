#!/bin/sh

find . -type d -exec chmod 755 {} +
find . -type f -exec chmod 644 {} +
find . -type f -name "*.sh" -exec chmod +x {} +

find . -type d -name "harib*" -exec bash -c "rm -f {}/*.bat" \;
find . -type f -print0 | xargs -0 nkf -u --overwrite -w
find . -type f -name "*.nkftmp*" -exec rm {} +

