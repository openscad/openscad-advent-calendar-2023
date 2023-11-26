// Bell

$fa = 2; $fs = 0.2;

hole = 3;

radius = 40;
height = 60;
ring = 15;
wall = 0.8;

f = function(x, xs, ys) ys * exp(((x * 3 / xs) ^ 4) / -18) + ring;

module outline() {
	points = [
		for (x = [0:0.1:radius]) [x, f(x, radius, height)],
		[radius, 0],
		[radius-0.1, 0],
		for (x = [radius:-0.1:0]) [x, f(x, radius, height) - 0.01],
	];
	intersection() {
		offset(wall/2) polygon(points);
		square(2 * [radius, height]);
	}
}

module shape() {
	rotate_extrude(convexity = 3)
		outline();
}

module pos(o, s, z) {
	for(a = [0:s:359.999])
		rotate(a)
			translate([radius + o, 0, z])
				children();
}

module ring(o, z) {
	rotate_extrude()
		translate([radius + o, z])
			children();
}

module bell() {
	difference() {
		color("darkgoldenrod") {
			shape();
		}
		color("gold") {
			ring(wall/2, 4) resize([0.5, 2]) circle(2);
			pos(wall/2, 12, 8) resize([0.5, 4, 2]) sphere(2);
			ring(wall/2, 12) resize([0.5, 2]) circle(2);
		}
		cylinder(d = hole, h = 100);
	}
}

bell();

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