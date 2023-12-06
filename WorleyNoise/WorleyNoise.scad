
  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

//https://en.wikipedia.org/wiki/Worley_noise

/*[Worley Noise]*/

size=[50,50];
grid=[8,8];
seed=50;
offset=[size.x/grid.x,size.x/grid.y]*.75;
r=0.5;
gradient=true;
dist=gradient?-.5:.5;

points=[
for(y=[0:grid.y])[for (x=[0:grid.x])[
size.x/grid.x*x + offset.x/2*rands(-1,1,2,seed+y*grid.x+x)[0],
size.y/grid.y*y + offset.y/2*rands(-1,1,2,seed+y*grid.x+x)[1]
]]
];


function pVal(x,y,points=points,offset=5)=
 let(
 valX= x<0?-offset
          :x>grid.x?size.x+offset
                     :points[min(max(y,0),grid.y)][x].x,
valY= y<0?-offset
         :y>grid.y?size.y+offset
                    :points[y][min(max(x,0),grid.x)].y
 )
[valX,valY];

//background
color("ivory")linear_extrude(gradient?.001:.25)square(size);

// cells
for(y=[0:grid.y],x=[0:grid.x])
let(p=[for (ix=[-1,0,1],iy=[-1,0,1])if(ix||iy)pVal(x+ix,y+iy)],cp=points[y][x])
  Shade(center=cp)offset(r-dist/2)offset(-r)Cell(cp=cp,p=p);


module Shade(center=[0,0],n=30,col=[1,.25,0],r=1.2,s=1.1,$fs=.2,$fa=1){

  if(gradient)for(i=[0:n])
    color(((1-1/n*i)*[1,1,1]+[col.r,-col.g,0]*0+[0,col.g,col.b]*0))
      render()intersection(){
        translate([0,0,i/n/20])cube([each size,.05/n]);
        translate(center)cylinder(.05,r1=size.x/grid.x,r2=.5);
        linear_extrude(5)children();
      }
  else translate(center)linear_extrude(1,scale=.85)translate(-center)children();
}

module Cell(cp=[0,0],p=[[1,1],[5,5],[1,5],[5,1]],pN=0){

distances=[for(i=[0:len(p)-1])norm(p[i]-cp)];
  difference(){
    intersection(){
      translate(cp)circle(max(distances),$fn=6);
      translate([1,1]*dist)square(size-[1,1]*dist*2);
    }
    for(i=[0:len(p)-1]){
    pH=(p[i]-cp)/2;
    deg=atan2(pH[0],pH[1]);
    translate(cp+pH)rotate(-deg)translate([-max(size)/2,0])square([max(size),max(size)]);
    } 
  }
}
