/**
* licence CC0
* Author: Yannick Battail
* https://github.com/yannickbattail/openscad-models/tree/main/twist
* Parameter selection and colors added for the openscad advent calender
*/

NbArms = 5; // [2:1:20]
Height = 80; // [1:1:200]
DistFromBorder = 20; // [1:1:200]
ArmRadius = 6; // [2:1:20]
TopCone_percentHeight = 80; // [0:5:100]
InsideCone = false;
Bottom = true;
TopHook = true;

/* [Animation] */
animArms = false;
animHeight = false;
animDistFromBorder = false;
animArmRadius = false;
animTopCone_percentHeight = false;

/* [Hidden] */
$vpt = [0, 0, 0];
$vpr = [80, 0, 40];
$vpd = 550;
$fa = 2;
$fs = 0.4;
epsi = 0.01;

animate();

module animate() {
    nbArms = animArms ? $t * 10 + 2 : NbArms;
    height = animHeight ? $t * 150 + 20 : Height;
    distFromBorder = animDistFromBorder ? $t * 200 + 30 : DistFromBorder;
    armRadius = animArmRadius ? $t * 18 + 2 : ArmRadius;
    topCone_percentHeight = animTopCone_percentHeight ? $t * 50 + 45 : TopCone_percentHeight;
    insideCone = InsideCone;
    bottom = Bottom;
    topHook = TopHook;

    coneTentacle(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook);
}

module coneTentacle(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook) {
    tentacle(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook);
    if (bottom) {
        mirror([0, 1, 0])
            mirror([0, 0, 1]) {
                tentacle(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook);
            }
    }
    if (topHook)
	color("Silver")
    top(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook);
}

module tentacle(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook) {
	color("Crimson")
    for (i = [0:nbArms]) {
        rotate([0, 0, i * 360 / nbArms])
            {
                linear_extrude(height, twist = 360, scale = [0, 0]) {
                    translate([distFromBorder, 0]) circle(r = armRadius);
                }
            }
    }
    if (insideCone) {
        color("MediumSeaGreen")
        cylinder(h = height, r1 = distFromBorder, r2 = 0);
    }
	color("MediumSeaGreen")
    difference() {
        width = distFromBorder + armRadius;
        cylinder(h = height, r1 = width, r2 = 0);
        translate([- width, - width, - epsi])
            cube([width * 2, width * 2, height * topCone_percentHeight / 100]);
    }
}

module top(nbArms, height, distFromBorder, armRadius, topCone_percentHeight, insideCone, bottom, topHook) {
    translate([0, 0, height - 1]) {
        translate([- 7, 0, 0])
            rotate([0, 45, 0])
                cylinder(h = 10, d = 2);
        translate([7, 0, 0])
            rotate([0, - 45, 00])
                cylinder(h = 10, d = 2);
        translate([0, 0, 7])
            sphere(d = 2);
    }
    invertPercent = 1 - topCone_percentHeight / 100;
    difference() {
        width = distFromBorder + armRadius;
        cylinder(h = height, r = (distFromBorder + armRadius) * invertPercent);
        translate([- width, - width, - epsi])
            cube([width * 2, width * 2, height * topCone_percentHeight / 100]);
    }
}

// Written by Yannick Battail
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
