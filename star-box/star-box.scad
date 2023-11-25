// Star box

/* [Part Selection] */
// Select part to generate
part = 0; // [0:Assembly, 1:Box, 2:Lid, 3:Plate]

/* [Hidden] */
$fa = 2; $fs = 0.2;

points = 5;
star_r1 = 25;
star_r2 = 30;

wall = 2;
height = 40;
tolerance = 0.2;

pa = 360 / 2 / points;

module shape() {
	star = [for (a = [0:(2 * points - 1)]) (star_r1 + star_r2 * ((a + 1) % 2)) * [cos(pa * a), sin(pa * a)]];
	polygon(star);
}

module chamfer(o) {
	offset(delta = o, chamfer = true) offset(-o) children();
}

module clip_pos(o = 0, z = 0) {
	r = star_r1 + star_r2;
	a = 2 * sin(pa) * star_r1; // side length of inner polygon
	ri = a / (2 * tan(pa)); // inner radius of polygon
	angle = atan((a/2) / (r - ri)); // half angle of the star
	offset = is_undef(o) ? r + wall : r - (2 * wall - o) / sin(angle) + 2 * wall;
	for (a = [0:points - 1]) rotate(a * 2 * pa) translate([offset, 0, z]) children();
}

module box() {
	difference() {
		linear_extrude(height)
			offset(wall + tolerance)
				shape();
		translate([0, 0, wall])
			linear_extrude(height)
				chamfer(2 * wall)
					offset(tolerance)
						shape();
		clip_pos(tolerance, z = height + -0.5 * wall)
			resize([5 * tolerance,2 * wall, 0.5 * wall])
				sphere(2 * wall);
	}
}

module lid() {
	difference() {
		linear_extrude(wall)
			offset(wall)
				shape();
		clip_pos(undef, z = wall)
			resize([4 * wall, 10 * wall, 0.8 * wall])
				sphere(5 * wall);
	}
	linear_extrude(2 * wall) difference() {
		chamfer(2 * wall)
			shape();
		offset(-wall)
			chamfer(2 * wall)
				shape();
	}
	clip_pos(z = 1.5 * wall)
		resize([8 * tolerance, 2 * wall, 0.5 * wall])
			sphere(2 * wall);
}


if (part == 0) {
	box();
	translate([0, 0, 2 * height]) rotate([180, 0, 0]) lid();
} else if (part == 1) {
	box();
} else if (part == 2) {
	lid();
} else if (part == 3) {
	translate([-star_r1 - star_r2 - 5 * wall, 0, 0]) lid();
	translate([star_r1 + star_r2 + 5 * wall, 0, 0]) box();
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