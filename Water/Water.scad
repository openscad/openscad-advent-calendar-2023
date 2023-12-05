  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

$vpr=[65,0,-$t*120];
$vpt=[20,30,0]/2;
Water(res=[80,120],ball=true);


module Water(size=[20,30],base=5,res=[20,30],ball=true){

step=[size.x/res.x, size.y/res.y];


amp=[0.08,.15,.5,.5,.5,.5,0.025]*2;//[0,0,0,1,1,0,0];// amplitudes
f=[15,20,10,5,6,2]; // frequencies
delta=[1,1.5,2,1.75,.5,.3]*1000*$t; // animation phase movement

fz=function(x,y) 
  sin(x*f.x+delta.x)*sin(y*f.y+delta.y)*amp.x//cross
  +sin(norm([x,y])*f[2]+delta[2])*amp.y//circular
  +sin(x*f[3]+delta[3])*amp[3]//x
  +sin(y*f[4]+delta[4])*amp[4]//y
  +sin((x-y)*f[5]+delta[5])*amp[5]// diagonal
  +rands(-1,1,1,x*y+$t)[0]*amp[6]// noise
  ;

points0=[
for(y=[0:res.y],x=[0:res.x])[x*step.x,y*step.y,fz(x,y)],
];

pointsBox=[
for(i=[ [ 0, 0, 1], [ 1, 0, 1], [ 1, 1, 1], [ 0, 1, 1] ]) [i.x*size.x, i.y*size.y, -base]
];

l0=len(points0);
faces=[


for(y=[0:res.y-1],x=[0:res.x -1])[x+1, x, x+res.x+1, x+res.x+2]+[1,1,1,1]*y*(res.x+1),
[0+l0,1+l0,2+l0,3+l0],// bottom
[1+l0,0+l0,for(x=[0:res.x])x],//side Y0
[3+l0,2+l0,for(x=[res.x-1:-1:-1])x+l0-res.x],//side Y+
[for(y=[res.y:-1:0])y*(res.x+1),0+l0,3+l0],//side X0
[2+l0,1+l0,for(y=[1:res.y+1])y*(res.x+1)-1],//side X+
];


points=concat(points0,pointsBox);
color("skyblue",.8)polyhedron(points,faces,convexity=5);

//Ball
if(ball)translate([40*step.x,60*step.y,fz(40,60)+1.5+sin($t*360)*.2])rotate([.5,.2,1]*($t*720+sin($t*100)*100))for(i=[0:2]){
col=["lime","blue","red"];
  rotate(i*60)color(col[i])scale([1,1.1,.985])sphere(2,$fs=.1,$fa=1);
  }
}