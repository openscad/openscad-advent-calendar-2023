// Christmas Lamp

select_theme = 0; // [0:Christmas, 1:Flower, 2:Winter, 3:Disco, 4:Cartoon]
select_part = 0; // [0:Assembly, 1:Base, 2:Top, 3:Bar, 4:Side-1, 5:Side-2, 6:Side-3, 7:Side-4]

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
		"snowflake.svg",								// https://www.printables.com/model/93356-christmas-decorations
		"gingerbread.svg",								// https://www.printables.com/model/93356-christmas-decorations
		"horse.svg",									// https://www.printables.com/model/93356-christmas-decorations
		"reindeer.svg",									// https://www.printables.com/model/93356-christmas-decorations
		"angel.svg",									// https://www.printables.com/model/93356-christmas-decorations
	] ,[
		"flower",
		SCALE_HORIZONTAL,
		"lemmling-Decorative-flower.svg",				// https://openclipart.org/detail/17495/decorative-flower
		"Flower21.svg",									// https://openclipart.org/detail/237229/flower-21
		"Flower29.svg",									// https://openclipart.org/detail/243417/flower-29
		"Flower46.svg",									// https://openclipart.org/detail/245438/flower-46
		"Flower113.svg",								// https://openclipart.org/detail/286026/flower-113
	], [
		"winter",
		SCALE_HORIZONTAL,
		"Snowflake-Silhouette.svg",						// https://openclipart.org/detail/292679/snowflake-silhouette
		"SnowFlake02.svg",								// https://openclipart.org/detail/268043/snowflake02
		"1481132994.svg",								// https://openclipart.org/detail/268042/snowflake03
		"SnowFlake04.svg",								// https://openclipart.org/detail/268022/snowflake04
		"Flake-05.svg",									// https://openclipart.org/detail/268054/snowflake05
	], [
		"disco",
		SCALE_VERTICAL,
		"1613135945spiral-logo-concept-svg.svg",		// https://openclipart.org/detail/328239/spiral-logo-concept
		"Disco-Dancer-3-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173764/disco-dancer-3
		"Disco-Dancer-2-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173763/disco-dancer-2
		"Disco-Dancer-1-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173762/disco-dancer-1
		"Disco-Dancer-4-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173765/disco-dancer-4
		"Disco-Dancer-5-Remix-by-Merlin2525.svg",		// https://openclipart.org/detail/173766/disco-dancer-5
		"Disco-Dancer-by-Merlin2525.svg",				// https://openclipart.org/detail/173767/disco-dancer
	], [
		"cartoon",
		SCALE_HORIZONTAL,
		"1611073397logo-design-element-vector-3.svg",	// https://openclipart.org/detail/327205/logotype-design-element-5
		"Cartoon dog.svg",								// https://openclipart.org/detail/337976/cartoon-dog
		"Suprised fish.svg",							// https://openclipart.org/detail/337979/surprised-fish
		"Screwball bird.svg",							// https://openclipart.org/detail/337972/screwball-bird
		"Hen with egg.svg",								// https://openclipart.org/detail/337970/hen-with-egg
	],
];

// Viewport: t = [10, 50, 50] / r = [35, 0, 15] / d = 500

function svg_filename(svg, idx) = str(svg[0], "/", svg[idx]);

module star(star_r1, star_r2, points = 5) {
	pa = 360 / 2 / points;
	star = [for (a = [0:(2 * points - 1)]) (star_r1 + star_r2 * ((a + 1) % 2)) * [cos(pa * a), sin(pa * a)]];
	rotate(90) polygon(star);
}

module shape() {
	intersection() {
		square(width, center = true);
		rotate(45) square(diagonal, center = true);
	}
}

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
	svg_width = 0.6 * side_short;
	svg_filename = str(svg[0], "/", svg[idx]);
	bar_height = height - base_height - top_height;
	difference() {
		linear_extrude(wall, convexity = 5)
			translate([-side_short / 2, 0])
				square([side_short, height]);
		color("white")
		for (a = [0:(bar_height / side_short) - 1])
			translate([0, base_height + side_border + (a + 0.2) * side_short, side_window_layer + eps])
				linear_extrude(wall, convexity = 5)
					resize([svg_width, -1], auto = true)
						offset(tolerance)
							import(svg_filename(svg, idx), center = true);
	}
}

module base() {
	difference() {
		union() {
			// base plate
			linear_extrude(wall)
				offset(2 * wall + tolerance)
						shape();
			// outer shell
			linear_extrude(base_height) difference() {
				offset(2 * wall + tolerance) shape();
				offset(delta = wall + tolerance) shape();
			}
			// inner shell
			linear_extrude(base_height) difference() {
				shape();
				offset(-wall) shape();
			}
			// inner base
			linear_extrude(2 * wall) shape();
		}
		translate([0, 0, wall]) cylinder(d = 40, h = 2 * wall);
	}
}

module stars() {
	for (a = [-2:2])
		translate([a * (side_short / 2 - 1.2 * wall), 0, 1.5 * top_height + width / 3 + wall])
			rotate([90, 0, 0])
					linear_extrude(width, center = true)
						star(top_height / 8, top_height / 5);
}

module top_roof(o, w, h) {
	hull() {
		linear_extrude(eps) difference()
			offset(o) children();
		translate([0, 0, h])
			linear_extrude(eps)
				offset(wall)
					square(w, center = true);
	}
}

module top_roof_diff(o, w, h, z) {
	difference() {
		translate([0, 0, z])
			top_roof(o, w, h) children();
		translate([0, 0, z - wall])
			top_roof(o, w, h) children();
	}
}

module top() {
	w1 = 2 * side_short + 4 * wall;
	h1 = top_height + width / 3 - wall;
	w2 = w1 + top_height;
	h2 = h1 + 2 * top_height;
	h3 = h2 + top_height / 2;
	h4 = h3 + top_height / 4;
	h5 = h4 + width / 3;
	difference() {
		union() {
			// roof
			top_roof_diff(2 * wall + tolerance, 2 * side_short, width / 3, top_height)
				shape();
			// outer shell
			linear_extrude(top_height + eps, convexity = 3) difference() {
				offset(2 * wall + tolerance) shape();
				offset(delta = wall + tolerance) shape();
			}
			// inner shell
			linear_extrude(top_height, convexity = 3) difference() {
				shape();
				offset(-wall) shape();
			}
			translate([0, 0, top_height - wall])
			linear_extrude(wall +eps, scale = 1.035, convexity = 3) difference() {
				shape();
				offset(-wall) shape();
			}
			// outer shell
			translate([0, 0, top_height])
			linear_extrude(wall, convexity = 3) difference() {
				offset(2 * wall + tolerance) shape();
				offset(-wall) shape();
			}
			// top
			translate([0, 0, h1])
				linear_extrude(2 * top_height, convexity = 3)
					offset(2 * wall) offset(-2 * wall)
						square(w1, center = true);

			translate([0, 0, h2])
				linear_extrude(top_height / 2, scale = w2 / w1, convexity = 3)
					offset(2 * wall) offset(-2 * wall)
						square(w1, center = true);

			translate([0, 0, h3])
				linear_extrude(top_height / 4)
					offset(2 * wall) offset(-2 * wall)
						square(w2, center = true);

			top_roof_diff(0, top_height / 2, width / 3, h4)
				offset(2 * wall) offset(-2 * wall)
					square(w2, center = true);
					
			translate([0, 0, h5 + top_height / 2 - wall / 3])
				sphere(top_height / 2);
		}
		stars();
		rotate(90) stars();
		linear_extrude(h4 + 1)
			offset(wall)
				square(2 * side_short, center = true);

	}

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