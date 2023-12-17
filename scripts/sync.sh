#!/bin/bash

YEAR="${YEAR:-$(date +%Y)}"
BASE="${1:-/home/openscad/www/advent-calendar-${YEAR}}"
DEST="openscad@files.openscad.org:${BASE}/"

rsync -rcltvP --chmod=D700,F644 index.js $(grep ^setDay index.js | sed -e "s/^.*,\s*dir:\s*'\([^']*\).*$/\1/") "${DEST}"
