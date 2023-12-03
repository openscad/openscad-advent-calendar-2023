// Christmas Lamp

select_theme = 0; // [0:Christmas, 1:Flower, 2:Winter, 3:Disco, 4:Cartoon]
select_part = 5; // [0:Assembly, 1:Base, 2:Top, 3:Bar, 4:Side-1, 5:Side-2, 6:Side-3, 7:Side-4]

/* [Hidden] */

SCALE_HORIZONTAL=1;
SCALE_VERTICAL=2;

width = 130;
height = 180;
side_long = 100;

eps = 0.01;
tolerance = 0.2;
wall = 2;

side_short = sqrt(2 * ((width - side_long) / 2) ^ 2);
diagonal = sqrt(2 * width ^ 2) - side_short;

base_height = 20;

top_height = 10;

side_svg_layer = 0.8;
side_window_layer = 0.4;
side_window_rounding = 2;
side_border = 8;
side_offset = base_height + 10;

svgs = [
	[
		"christmas",
		SCALE_HORIZONTAL,
		"",
		"gingerbread.svg",								// https://www.printables.com/model/93356-christmas-decorations
		"horse.svg",									// https://www.printables.com/model/93356-christmas-decorations
		"",
		"",
	] ,[
		"flower",
		SCALE_HORIZONTAL,
		"",
		"Flower21.svg",									// https://openclipart.org/detail/237229/flower-21
		"Flower29.svg",									// https://openclipart.org/detail/243417/flower-29
		"",
		"",
	], [
		"winter",
		SCALE_HORIZONTAL,
		"",
		"SnowFlake02.svg",								// https://openclipart.org/detail/268043/snowflake02
		"1481132994.svg",								// https://openclipart.org/detail/268042/snowflake03
		"",
		"",
	], [
		"disco",
		SCALE_VERTICAL,
		"",
		"Disco-Dancer-3-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173764/disco-dancer-3
		"Disco-Dancer-2-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173763/disco-dancer-2
		"",
		"",
	], [
		"cartoon",
		SCALE_HORIZONTAL,
		"",
		"Cartoon dog.svg",								// https://openclipart.org/detail/337976/cartoon-dog
		"Suprised fish.svg",							// https://openclipart.org/detail/337979/surprised-fish
		"",
		"",
	],
];

// Viewport: t = [10, 50, 50] / r = [35, 0, 15] / d = 500

function svg_filename(svg, idx) = str(svg[0], "/", svg[idx]);

module side(svg, idx) {
	scale = (side_long + (wall - tolerance)) / side_long;
	window_width = side_long - 2 * side_border;
	window_height = height - base_height - top_height;
	svg_width = side_long - 3 * side_border;
	svg_height = window_height - 3 * side_border;
	svg_resize = svg[1] == SCALE_HORIZONTAL ? [svg_width, -1] : [-1, svg_height];
	color("black")
	translate([0, base_height + window_height / 2 - side_border, 0])
		linear_extrude(side_svg_layer, convexity = 5)
			resize(svg_resize, auto = true)
				offset(tolerance)
					if (len(svg[idx]) > 0)
						import(svg_filename(svg, idx), center = true);
	difference() {
		color("black")
		linear_extrude(wall, scale = [scale, 1], convexity = 5)
			translate([-side_long / 2, 0])
				square([side_long, height]);
		color("lightgray")
		translate([-window_width / 2, base_height, side_window_layer + eps])
			linear_extrude(wall, convexity = 5)
				offset(side_window_rounding)
					offset(-side_window_rounding)
						square([window_width, window_height]);
	}
}

module bar(svg, idx) {
}

module base() {
}

module top() {
}

svg = svgs[select_theme];
if (select_part == 0) {
	base();
	translate([0, -width / 2, wall]) rotate([90, 0, 0]) side(svg, 3);
	rotate(90) translate([0, -width / 2, wall]) rotate([90, 0, 0]) side(svg, 4);
	rotate(180) translate([0, -width / 2, wall]) rotate([90, 0, 0]) side(svg, 5);
	rotate(270) translate([0, -width / 2, wall]) rotate([90, 0, 0]) side(svg, 6);
	rotate(45) translate([0, -diagonal / 2, wall]) rotate([90, 0, 0]) bar(svg, 2);
	rotate(135) translate([0, -diagonal / 2, wall]) rotate([90, 0, 0]) bar(svg, 2);
	rotate(225) translate([0, -diagonal / 2, wall]) rotate([90, 0, 0]) bar(svg, 2);
	rotate(315) translate([0, -diagonal / 2, wall]) rotate([90, 0, 0]) bar(svg, 2);
	translate([0, 0, height - top_height + 2 * wall]) top();
} else if (select_part == 1) {
	base();
} else if (select_part == 2) {
	top();
} else if (select_part == 3) {
	bar(svg, 2);
} else if (select_part == 4) {
	side(svg, 3);
} else if (select_part == 5) {
	side(svg, 4);
} else if (select_part == 6) {
	side(svg, 5);
} else if (select_part == 7) {
	side(svg, 6);
}

$fa = 2; $fs = 0.2;

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
