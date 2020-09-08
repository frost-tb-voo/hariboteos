#!/bin/sh

find . -type d -exec chmod 755 {} +
find . -type f -exec chmod 644 {} +

find . -type d -name "harib*" -exec bash -c "rm {}/*.bat" \;
find . -type f -print0 | xargs -0 nkf -u --overwrite -w

chmod +x *.sh
