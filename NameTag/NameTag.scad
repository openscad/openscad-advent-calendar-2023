  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/


// experimental features lazy union roof and textmetrics in openSCAD 2023 are used (activated) !

$fa=1;
$fs=0.25;


name="openSCAD";

inlay=0;//[0:none,1:inlay,2:both]
size=5;
spacing=1.15;
h=2;
back=.5;
hole=3;
slit=1;

font="calibri";//["Calibri:style=Regular","Century Gothic:style=Regular","Hazeer Cello:style=Regular"]


Tag(size,spacing,h,hole,back,inlay=0);
if(inlay)Tag(size,spacing,h,hole,back,inlay=1);

if($preview)translate([0,size+5,0])Tag(size,spacing,h,hole,back,inlay=2);




module Tag(size=5,spacing=1.15,h=2,hole=2,back=.35,inlay){

tSize=textmetrics(name,size,font=font,spacing=spacing);
echo(tSize);
sca=8;
rim=1;
back=min(h-.25,back);
if(!inlay||inlay==2)difference(){
  union(){
    intersection(){
      scale([1,1,sca])roof(convexity=5)
        difference(){
          square(150,true);
          translate([rim+hole/2,-0.5-tSize.descent])text(name,font=font,size=size,spacing=spacing);
          hull(){
          circle(hole/2);
          if(slit)translate([0,tSize.size.y-1])circle(hole/2);
          }
        }
      linear_extrude(h)offset(rim+hole/2,$fs=.45)square([tSize.advance.x+1,tSize.size.y]+[1,1]*-4+[4.5,3]);
    }
//back
   color("navy") linear_extrude(back)offset(rim+hole/2,$fs=.45)square([tSize.advance.x+1,tSize.size.y]+[1,1]*-4+[4.5,3]);
  }
  hull(){
    cylinder(50,d=hole,center=true);//hole
    if(slit)translate([0,tSize.size.y-1])cylinder(50,d=hole,center=true);//hole
  }
  
  //cube(500);
}


if(inlay)color("steelblue")translate([0,0,h+.01])mirror([0,0,1])intersection(){
  scale([1,1,sca])roof(convexity=5)translate([rim+hole/2,-0.5-tSize.descent])offset(h/sca-.01)text(name,font=font,size=size,spacing=spacing);
   linear_extrude(h-back-.01)offset(delta=50)square([tSize.advance.x,tSize.size.y]);
}
}