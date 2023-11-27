  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

// Stringart Star


/*[Print Settings]*/
layerHeight = 0.2;
lineWidth   = 0.45;

/*[Star Parameter]*/
points      = 6;
radius      = 45;
strings     = 10;
hangerD     = 10;


StringStar();


module StringStar(p=points, r=radius,strings=strings, hD=hangerD, lH=layerHeight, lW=lineWidth){
h= 1.5 + strings * lH;
  for (i = [0:p-1]) rotate (i* 360/p){
    color("darkgreen")Line ([0,0],[0,radius], h, lW*2);
  
    if(i&&hD || !hD)color("gold")translate([0,radius]){
    linear_extrude(1,scale = 1.25)scale(1/1.25)Star(p, [r,r/2]/5);
    translate([0,0,1])linear_extrude(h-1,scale=.1)Star(p, [r,r/2]/5);
    }
  
    for (s = [1:strings]){
      p1 = [0, radius / (strings +1 ) * s];
      p2 = [ sin (360/p), cos(360/p) ] * (radius - radius / (strings + 1) * s);
      translate([0,0, 1 + s * lH])Line(p1,p2);
    }
  }
 
// Hanger
  if(hD)translate([0,radius+hD/2+lW*2]) linear_extrude(1) Hanger (d=hD, od=hD + lW*4);

}

module Hanger (d=hangerD, od=hangerD+2, $fs=.2, $fa=1)
  offset(-2) offset(2)
    difference(){
     offset(-5) offset(5) union(){
      circle(od/2);
      translate([0,- (5+d/2)])square([(od-d)/2,10],center=true);
      }
     circle(d/2);
    }

module Line(p1,p2,h=layerHeight - .01,lW=lineWidth){
  linear_extrude(h)
    hull(){
      translate(p1)circle(d=lW,$fn=12);
      translate(p2)circle(d=lW,$fn=12);
    }
}

module Star (p=points, r=[10,5])
  polygon ( 
    [  for (i=[0:p*2-1])
        let(rot=180/p*i) 
        [sin(rot), cos(rot)]*r[i%2] 
    ] 
  );
