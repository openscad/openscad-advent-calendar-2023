/* 
    Purpose: Xmas ornament
    Author: Sohler Guenther
    with CC0 1.0. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0
    many others @ https://www.thingiverse.com/thing:2713124
*/    

$fa = 2; $fs=1;

l=20; // Length of one side

facemode=1;
// 0: no face
// 1: plain faces
// 2: cones

r_edge=2;
r_corner=4;

conehight=15;

///////////////////////////
// Utility Functions
///////////////////////////

function rotpt(pt,ang)= // Rotate Point along an angle
    [pt[0]*cos(ang)-pt[1]*sin(ang),
    pt[0]*sin(ang)+pt[1]*cos(ang)];              

function ptfunc(i,lx,ang)= // Calculates all Points of a regular polygon
    (i > 0)
    ?rotpt(ptfunc(i-1,lx,ang)+[lx,0],ang)
    :[0,0];

function centerfunc(pts,i,n)= //Calculates the center point of a point list
    i==n?centerfunc(pts,i-1,n)/n:
    i==0?pts[i]:
    pts[i]+centerfunc(pts,i-1,n);

// calculate the angle between 3 polyeders
function cosrw(n)=
    cos(180-360/n);

function sinrw(n)=
    sin(180-360/n);

// returns angle bewtween polygon n1,n2 with no in between
function angle_3poly(n1,n2,no)=
    acos((cosrw(no)-cosrw(n1)*cosrw(n2))/(sinrw(n1)*sinrw(n2)));


// One Face of the Polyeder
module face(n)
{
    pts=[for (i =[0:n-1]) ptfunc(i,l,360/n) ];
     
    
    if(facemode == 1)
    {
        color("green",alpha=0.5)
        translate([0,0,-0.1])
        linear_extrude(height=0.1)
        {
            polygon(pts);
        }
    }
    if(facemode == 2)
    {
        ct=centerfunc(pts,len(pts),len(pts));
        hull()
        {
            translate([0,0,-0.1])
            linear_extrude(height=0.1)
            {
                polygon(pts);
            }
            translate([ct[0],ct[1],conehight])
                sphere(r=0.1);
        }
    }
  
    if(r_edge > 0)
    {
        n=len(pts);
        for(i=[0:n-1])
        {
            color("yellow")
            hull()
            {
                translate(pts[i]) sphere(r=r_edge);
                translate(pts[(i+1)%n]) sphere(r=r_edge);
            }
        }
    }
	// Render only spheres of the pentagons
    if(r_corner > 0 && len(pts) == 5)
    {
        for(i=[0:4])
        {
            translate(pts[i]) color("purple") sphere(r=r_corner);
        }
    }

}


module polyeder_rot(info,in,i,ang)
{
    if(i == 0)
    {
        polyeder(info,in); 
    }
    else
    {
        translate([l/2,0,0])
            rotate([0,0,ang])
            translate([l/2,0,0])
            polyeder_rot(info,in,i-1,ang);
    }
     
}

module polyeder(info,inbase) 
{
   rotate([inbase[4],180,0]) 
    {
        n=inbase[3];
        translate([l/2,0,0])
            face(n); 
        cur=inbase[2];

        for(in=info) 
        {
             if(in[0] == cur)
             {
                  polyeder_rot(info,in,in[1],360/n);
             }
        }
    }
}


wsnubdod33=164.1752;
wsnubdod35=152.93;
wsnubcube33=153.2347;
wsnubcube34=142.98;


function snubdodecafunc(i)= // snub dodecahedron
    i==0?concat([[-1,0,i,5,0]],snubdodecafunc(i+1)):
    i<6?concat([[0,i-1,i,3,wsnubdod35]],snubdodecafunc(i+1)):
    i<16?concat([[i-5,1,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<21?concat([[i-5,2,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<26?concat([[i-5,1,i,5,wsnubdod35]],snubdodecafunc(i+1)):
    i<31?concat([[i-5,2,i,3,wsnubdod35]],snubdodecafunc(i+1)):
    i<36?concat([[i-5,2,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<41?concat([[i-5,1,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<56?concat([[i-10,2,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<61?concat([[i-10,1,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<66?concat([[i-15,2,i,5,wsnubdod35]],snubdodecafunc(i+1)):
    i<71?concat([[i-5,3,i,3,wsnubdod35]],snubdodecafunc(i+1)):
    i<86?concat([[i-5,1,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    i<91?concat([[i-5,2,i,3,wsnubdod33]],snubdodecafunc(i+1)):
    [[90,2,91,5,wsnubdod35]];
    

info=snubdodecafunc(0);  

polyeder(info,info[0]);     // Finally assemble the Polyeder

// Written by Guenther Sohler
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
