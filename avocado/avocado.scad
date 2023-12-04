$fs=0.4;
$fa=2;

color("green") body();
color("yellow") bodyFront();
color("brown") stone();
color("black") translate([0,0,60]) face();

module body(){
intersection(){
        hull(){
        sphere(r=50);
        translate([0,0,60]) sphere(r=30);
    }
    translate([-100,0,-100]) cube([200,100,200]);
}
}

module bodyFront(){
    translate([0,-0.1,0])
    scale(0.9)
    intersection(){
    body();
    translate([-100,0,-100]) cube([200,1,200]);
    }
}

module stone(){
 hull(){
sphere(r=20);
translate([0,0,10]) sphere(r=20);
}
}

module face() {
    translate([-8,0,0]) sphere(r=3);
    translate([ 8,0,0]) sphere(r=3);
    rotate([90,0,0])
    rotate([0,0,-90-75/2]) rotate_extrude(angle=75) translate([10,0]) intersection() {
    circle(r=2);
    translate([0,-2])square([2,4]);
    }

}

// Written in 2023 by Scopeuk
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.