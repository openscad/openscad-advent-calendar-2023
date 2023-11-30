// Printable christmas tree

/* [Part Selection] */
// Select part to generate
part = 0; // [0:Assembly, 1:Tree, 2:Star, 3:Plate]

/* [Hidden] */
$fa = 2; $fs = 0.2;

height = 100;
tree_r1 = 30;
tree_r2 = 5;
star_r1 = 4;
star_r2 = 6;
star_height = 4;

tree = [for (a = [0:0.25:359.999]) (tree_r1 + tree_r2 * sin(13*a) * sin(23*a)) * [sin(a), cos(a)]];
star = [for (a = [0:9]) (star_r1 + star_r2 * (a % 2)) * [sin(36 * a), cos(36 * a)]];

module tree() {
	color("darkgreen")
	linear_extrude(height = height, scale = 0.02, twist = 190, slices = 100) minkowski() {
		polygon(tree);
		circle(d = 1);
	}
	translate([0, 0, height])
		cylinder(d = 2, h = star_r1, center = true);
}

module star() {
	color("gold")
	difference() {
		linear_extrude(star_height, center = true) minkowski() {
			polygon(star);
			circle(d = 0.6);
		}
		translate([0, star_r1, 0])
			rotate([0, 90, -90])
				cylinder(d = 2.5, h = star_r2, center = true);
	}
}

if (part == 0) {
	tree();
	translate([0, 0, height + star_r1]) rotate([-90, 0, 0]) star();
} else if (part == 1) {
	tree();
} else if (part == 2) {
	star();
} else if (part == 3) {
	tree();
	translate([2 * tree_r1, 0, star_height / 2]) star();
}

// Written in 2023 by Torsten Paul <Torsten.Paul@gmx.de>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.