#!/bin/bash

copy_svg() {
	d="$1"
	target="$2"
	nr="$3"
	f=$(grep -A"$nr" "\"$d\"" Lamp/Lamp.scad | tail -n1 | sed -e 's/^[^"]*"//; s/".*//')
	cp -v "Lamp"/"$d"/"$f" "$target"
}

rm -rfv Lamp-Part?
for d in $(find Lamp -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
do
	for nr in $(seq 1 4)
	do
		target="Lamp-Part$nr"/"$d"
		mkdir -p "$target"
		copy_svg "$d" "$target" "$(($nr + 2))"
	done
	target="Lamp-Part5"/"$d"
	mkdir -p "$target"
	copy_svg "$d" "$target" 2
done

for nr in $(seq 1 4)
do
	cp -v "Lamp/Lamp-Part$nr.scad" "Lamp-Part$nr"/
	cp -v "Lamp/Lamp-christmas_Side$nr."* "Lamp-Part$nr"/
done
