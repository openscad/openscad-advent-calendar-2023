#!/bin/bash

copy_svg() {
	d="$1"
	target="$2"
	nr="$3"
	f=$(grep -A"$nr" "\"$d\"" Lamp/Lamp.scad | tail -n1 | sed -e 's/^[^"]*"//; s/".*//')
	cp -v "Lamp"/"$d"/"$f" "$target"
}

rm -rfv Lamp-Part?
for nr in $(seq 1 6)
do
	mkdir "Lamp-Part$nr"
done

for d in $(find Lamp -mindepth 1 -maxdepth 1 -type d -printf '%f\n')
do
	for nr in $(seq 1 4)
	do
		target="Lamp-Part$nr"/"$d"
		mkdir "$target"
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
cp -v "Lamp/Lamp-Part5.scad" "Lamp-Part5"/
cp -v "Lamp/Lamp-christmas_Bar."* "Lamp-Part5"/
cp -v "Lamp/Lamp.scad" "Lamp-Part6"/
cp -v "Lamp/Lamp.png" "Lamp-Part6"/
cp -v "Lamp/Lamp_Base."* "Lamp-Part6"/
cp -v "Lamp/Lamp_Top."* "Lamp-Part6"/
