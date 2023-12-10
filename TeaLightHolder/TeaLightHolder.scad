// Star-Maker by u/ardvarkmadman
// Star shaped holder for 40mm led Tea-Light
// https://www.reddit.com/r/openscad/comments/18f7hv3/star_shaped_holder_for_40mm_led_tealight_cic/

step=5;		//number of points
inner=40;	//inner diameter
outer=80;	//outer diameter
wide=10;	//width of line before offset applied
off=-4;		//offset applied to star - may be negative, if off < wide*2
ht=40;		//height parameter of linear_extrude
sc=1.5; 	//scale parameter of linear_extrude
$fn=36;		//resolution

color("bisque")
ring(sc);

module ring(sc){
	linear_extrude(ht,scale=sc)
		offset(off)
			profile();}

module profile(){
	for(i=[1:step]){
		hull(){ //right
			inner(i);
			outer(i);}
		hull(){ //left
			inner(i);
			outer(i-1);}}}
module inner(i){
	rotate(i*360/step)
		translate([inner/2,0])
			circle(wide/2);}
module outer(i){
	rotate(i*360/step+360/step/2)
		translate([outer/2,0])
			circle(wide/2);}

// Written in 2023 by u/ardvarkmadman
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
