  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/


/*[ StarChain ]*/
no=150;


Spiral(r=25,no){
  color("gold")rotate(90){
    translate([0,0,+1])linear_extrude(2,scale=.1)Star(tip=$tips,r=$d/2.25*[1,.5]);
    translate([0,0,+1])scale([1,1,-1])linear_extrude(1,scale=.75)Star(tip=$tips,r=$d/2.25*[1,.5]);
  }
  color("skyblue")rotate(90){
    //translate([0,0,+1])roof(method="straight")Snowflake(r=$d/2.5);
    linear_extrude(2) Snowflake(r=$d/2.5);
  }
}



module Spiral(rec=no,r=25,add=12,$d=10){
rot=360 / (PI*r*2) * $d;
rNext=r+add/360*rot;
if(rec)rotate(rot)Spiral(rec=rec-1,r=rNext,$d=$d ){
  children(index=0);
  if($children==2)children(index=1);
  }

union(){
  $d=$d + rands(-4,3,1,rec)[0];
  $tips=floor (rands(5,8,1,rec)[0]);
  idx=rec%$children;
  
  translate([0,r,+1])children(index=idx);
}

linear_extrude(.5,$fs=.4,$fa=1){

  hull(){
    translate([0,r])circle(.75);
    if(rec)rotate(rot)translate([0,rNext])circle(.75);
  }
  if(rec==0)rotate(rot)translate([0,rNext])rotate(-5)difference(){
    offset(-5)offset(5)union(){
      circle(6);
      translate([0,-.5])square([$d/2+6,1]);
    }
    circle(5);
  }
}
}


module Snowflake(r=10,line=.75){
  for(rot=[0:60:359]) rotate (rot){
  translate([-line/2,0])square([line,r]);
  translate([0,r-r/3])rotate( 60)translate([-line/2,0])square([line,r/3]);
  translate([0,r-r/3])rotate(-60)translate([-line/2,0])square([line,r/3]);
  
  }
}

module Star(tip=5,r=[10,5]){
  step=180/tip;
  points=[ for(rot=[0:tip*2 -1])[sin(rot*step),cos(rot*step)] * r[rot%2] ];
  polygon(points);
}