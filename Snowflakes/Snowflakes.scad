  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

//Snowflakes

area=[80,120];
seed=58;


color("lightskyblue",.4)Place(h=1);

*Flake(seed=181);

module Place(area=area,num=rands(4,10,1,seed)[0],seed=seed,size=20,h=0){


if(num>=1){
 area2=area.x>area.y?[area.x/2,area.y]:[area.x,area.y/2];
 
 translate(area.x>area.y?[area.x/2,0]:[0,area.y/2])Place(area=area2, num = floor(num/2), seed = rands(-9999,9999,1,seed*PI)[0], size=rands(5,max(area2)/2,1,seed*PI)[0],h=h);
 
 Place(area=area2, num = floor(num/2) , seed = rands(-9999,9999,1,seed)[0], size=rands(5,max(area2)/2,1,seed)[0],h=h);
 }

pos = [
 rands(0+size/2,area.x-size/2,1,seed)[0],
 rands(0+size/2,area.y-size/2,1,seed*PI)[0],
 ];
if(h)linear_extrude(rands(0,h,1,seed*PI^2)[0])translate(pos)Flake(size=size,seed=seed);
else translate(pos)Flake(size=size,seed=seed);


}


module Flake (size=20,seed=42,rad=.2,$fs=.2,$fa=1){
  random=rands(-1,1,6,seed);
  rotate(random[0]*30) 
  offset(-rad) offset(rad) offset(rad) offset(-rad)
  for (rot=[0:60:359])rotate(rot){
    for(salt=[0:2+ceil(abs(random[1])*8)]){
    d=rands(.25,6,1,random[2])[0];
     translate([0,rands(0,size/2-d/2,1,random[3]+salt)[0]])difference(){
     circle(d=d,$fn=6);
     if(d>3)circle(d=d-1,$fn=6);
     }
    }
// center ray
    hull(){
     r=rands(1,2,1,random[4])[0];
      circle(.25,$fn=6);
      translate([0,size/2-r])rotate(30)circle(r,$fn=6);
    }
// arms
    if(random[5]>0)translate([0,rands(size/4,size/2-2,1,random[5])[0]]){
    r=rands(.25,1,1,random[5])[0];
      rotate(60)hull(){
        circle(.25,$fn=6);
        translate([0,size/5-r])rotate(30)circle(r,$fn=6);
      }
      rotate(-60)hull(){
        circle(.25,$fn=6);
        translate([0,size/5-r])rotate(30)circle(r,$fn=6);
      }    
    }
    
    
  }
}