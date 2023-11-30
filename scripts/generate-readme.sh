#!/bin/bash

export TZ=UTC

YEAR=${YEAR:-$(date +%Y)}
URL="https://github.com/openscad/openscad-advent-calendar-${YEAR}/blob/main"

awk '/^##/ { hide = 1} { if (!hide) print $0 }' README.md
DAY=0
for DIR in $(grep ^setDay index.js | sed -e "s/^.*,\s*dir:\s*'\([^']*\).*$/\1/")
do
	DAY=$(( $DAY + 1 ))
	IMG=$(grep -A1 "dir: .${DIR}." index.js | tail -n1 | sed -e "s/^.*img:\s*'\([^']*\).*$/\1/")
	cat << EOF
## ${DAY}. ${DIR}
<img src="${URL}/${DIR}/${IMG}" width="250">

EOF
done
