  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/


/*[ StarChain ]*/
no=150;
link=false;

Spiral(r=25,no){
  color("gold")rotate(90){
    translate([0,0,+1])linear_extrude(2,scale=.1)Star(tip=$tips,r=$d/2.25*[1,.5]);
    translate([0,0,+1])scale([1,1,-1])linear_extrude(1,scale=.75)Star(tip=$tips,r=$d/2.25*[1,.5]);
  }
  color("skyblue")rotate(90){
    //translate([0,0,+1.5])roof(method="straight")Snowflake(r=$d/2.5);
    linear_extrude(1.51) Snowflake(r=$d/2.5);
  }

}



module Spiral(rec=no,r=25,add=12,$d=15,link=link){
rot=360 / (PI*r*2) * $d;
rNext=r+add/360*rot;
  if(rec>0)rotate(rot){
    if(!$children)Spiral(rec=rec-1,r=rNext,$d=$d, link=link );
    if($children==1)Spiral(rec=rec-1,r=rNext,$d=$d, link=link )children(index=0);
    if($children==2)Spiral(rec=rec-1,r=rNext,$d=$d, link=link ){
      children(index=0);
      children(index=1);
    }
    if($children==3)Spiral(rec=rec-1,r=rNext,$d=$d, link=link ){
      children(index=0);
      children(index=1);
      children(index=2);
    }
  }

  union(){
    $d=10 + rands(-4,3,1,rec)[0];
    $tips=floor (rands(5,8,1,rec)[0]);
    idx=rec%$children;
    if($children)translate([0,r,0])children(index=idx);
  }
  deg=-atan((add/360*rot) /$d);
  if(link)translate([0,r,0])rotate(deg)Link(h=2,s=1,l=$d-.5,deg=-deg*3);
  
  linear_extrude(.5,$fs=.4,$fa=1){
    if(!link)hull(){
      translate([0,r])circle(.75);
      if(rec)rotate(rot)translate([0,rNext])circle(.75);
    }
    // end loop
    if(rec==0)rotate(rot)translate([0,rNext])rotate(deg*4)difference(){
      offset(-5)offset(5)union(){
        circle(6);
        translate([0,-.5])square([$d/2+6,1]);
      }
      circle(5);
    }
  }
}

module Link (h=1,s=1,l=10,deg=10){
h1=h/4;
l1=l/2-3;
l2=l/2+1;

    rotate(-deg)translate([l1/2,0,h1/2])cube([l1,s,h1],true);
    rotate(deg)translate([-l2/2,0,h1/2])cube([l2,s,h1],true);
    
    rotate(-deg)translate([l/2+.75,0]){
    sX=4*s+1;sY=2*s+1;
      translate([-sX/2+s,sY/2,h/4])cube([sX,s,h/2],true);
      translate([-sX/2+s,-sY/2,h/4])cube([sX,s,h/2],true);
      translate([+s/2,0,h/2])cube([s,sY,h1],true);
      translate([-sX+s*1.5,0,h1/2])cube([s,sY,h1],true);
    }
    rotate(deg)translate([-l/2-.75,0]){
    sX=4*s+1;
      translate([-s/2,0,h/2])cube([s,s,h],true);
      translate([sX-s,0,h/2])cube([s,s,h],true);
      translate([sX/2-s/2,0,h-h1/2])cube([sX,s,h1],true);
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