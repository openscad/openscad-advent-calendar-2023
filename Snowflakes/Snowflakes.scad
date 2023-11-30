  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

//Snowflakes

area=[100,150];
seed=53;


color("lightskyblue",.65)Place(h=1.5,seed=seed);
cube([each area,.2]);

*Flake(seed=181);

module Place(area=area,num=rands(4,10,1,seed)[0],seed=seed,size=min(area)/1.5,h=0){


if(num>0){
 area2=area.x>area.y?[area.x/2,area.y]:[area.x,area.y/2];
 
 translate(area.x>area.y?[area.x/2,0]:[0,area.y/2])Place(area=area2, num = floor(num/2), seed = rands(-9999,9999,1,seed*PI)[0], size=min(area2)*rands(0,0.5,1,seed*PI)[0],h=h);
 
 Place(area=area2, num = floor(num/2) , seed = rands(-9999,9999,1,seed)[0], size=min(area2)*rands(0.1,0.5,1,seed)[0],h=h);
 
 }
 
//translate([0,0,num])offset(-1)square(area);

pos = [
 rands(0+size/2,max(size/2,area.x-size/2),1,seed)[0],
 rands(0+size/2,max(size/2,area.y-size/2),1,seed*PI)[0],
 ];
 
if(size>2.5)if(h)linear_extrude(rands(.5,h,1,seed*PI^2)[0])
              translate(pos)Flake(size=size,seed=seed );
            else translate(pos)Flake(size=size,seed=seed);
}


module Flake (size=20,seed=42,rad=0.1,$fs=.2,$fa=1){
  random=rands(-1,1,6,seed);
  rotate(random[0]*30) 
  offset(-rad) offset(rad) offset(rad) offset(-rad)
  for (rot=[0:60:359])rotate(rot){
    for(salt=[0:2+ceil(abs(random[1])*8)]){
    d=rands(max(.4,size/20),size/5,1,random[2]+salt)[0];
     translate([0,rands(0,size/2-d/2,1,random[3]+salt)[0]])rotate(30)difference(){
     circle(d=d,$fn=6);
     if(d>2)circle(d=d-1,$fn=6);
     }
    }
// center ray
    hull(){
     r=rands(max(.4,size/50),size/30,1,random[4])[0];
      circle(max(.5,size/100),$fn=6);
      translate([0,size/2-r])rotate(30)circle(r,$fn=6);
    }
// arms
    if(size>10)translate([0,rands(size/5,size/2-3.5,1,random[5])[0]]){
    r=rands(.25,size/80,1,random[5])[0];
    r2=max(rad,rands(r/3,r,1,random[5])[0]);
      rotate(60)hull(){
        circle(r2,$fn=6);
        translate([0,size/6-r])rotate(30)circle(r,$fn=6);
      }
      rotate(-60)hull(){
        circle(r2,$fn=6);
        translate([0,size/6-r])rotate(30)circle(r,$fn=6);
      }    
    }
    
    
  }
}