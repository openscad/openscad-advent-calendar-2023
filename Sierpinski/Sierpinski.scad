// Modified Sierpiński carpet
// https://en.wikipedia.org/wiki/Sierpi%C5%84ski_carpet

level = 4;

layer = 0.2;
base_height = 0.4;
size = [100, 100];
border = 0;

module _sierpinski(i, cnt, h, o, s) {
	r = [s.x / 3, s.y / 3, h + i * layer];
	
	color(hsv((cnt - i - 1) / cnt / 1.3, 0.5, 0.9))
		translate(o + [r.x, r.y, layer])
			cube(r);

	if (i > 0)
		for(x = [0:2], y = [0:2])
			if ((x != 1) || (y != 1))
				_sierpinski(i - 1, cnt, h, [x * r.x + o.x, y * r.y + o.y, 0], r);
}

module sierpinski(i, r = [size.x, size.y, base_height]) {
	color("black") {
		cube(r);
		if (border > 0) {
			linear_extrude(base_height + (level + 1) * layer) difference() {
				offset(border) square(size.xy);
				square(size.xy);
			}
		}
	}
	_sierpinski(i, i + 1, r.z, [0, 0, 0], r);
}

sierpinski(level);

// HSV to RGB conversion
function doHsvMatrix(h,s,v,p,q,t,a=1)=[h<1?v:h<2?q:h<3?p:h<4?p:h<5?t:v,h<1?t:h<2?v:h<3?v:h<4?q:h<5?p:p,h<1?p:h<2?p:h<3?t:h<4?v:h<5?v:q,a];
function hsv(h,s=1,v=1,a=1)=doHsvMatrix((h%1)*6,s<0?0:s>1?1:s,v<0?0:v>1?1:v,v*(1-s),v*(1-s*((h%1)*6-floor((h%1)*6))),v*(1-s*(1-((h%1)*6-floor((h%1)*6)))),a);

// Written in 2023 by Torsten Paul <Torsten.Paul@gmx.de>
// HSV color conversion functions by Yona Appletree (Hypher)
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
