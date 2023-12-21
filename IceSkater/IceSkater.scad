// Created in 2023 by Ryan A. Colyer.
// This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/

// View, Animate, FPS: 30, Steps: 200

module IceSkater(bend, extend, crouch) {
  translate([0, 0, 2])
  rotate([0, -20*bend, 0]) {
    translate([-(1-bend)*2-1, bend*4-1, 0]) {
      translate([0.75, -2, -2]) cube([0.5, 4, 3]);
      rotate([bend*15+crouch*45, -bend*5, 0]) {
        cube([2,2,9]);
        translate([0,0,9]) rotate([-2*crouch*45, 0, 0]) rotate([-bend*5, 0, 0]) {
          cube([2,2,9]);
        }
      }
    }
    translate([(1-bend)*2-1, -bend*4-1, 0]) {
      translate([0.75, -2, -2]) cube([0.5, 4, 3]);
      rotate([bend*0+crouch*45, bend*5, 0]) {
        cube([2,2,9]);
        translate([0,0,9]) rotate([-2*crouch*45, 0, 0]) rotate([-bend*25, 0, 0]) {
          cube([2,2,9]);
        }
      }
    }
    rotate([crouch*45, 0, 0]) translate([0,0,9]) rotate([-2*crouch*45, 0, 0]) {
      translate([0,0,8]) rotate([crouch*45, 0, 0]) {
        scale([2,1,1]) cylinder(r=1.5, h=15, $fn=10);
        translate([0, 0, 14.9]) {
          cylinder(r=1.4, h=4, $fn=8);
          translate([0, 0, 4]) sphere(r=3, $fn=12);
          translate([-5, 0, -1]) {
            rotate([170-80*extend, 20*extend, -10*extend]) {
              translate([0,-1,0]) cube([2,2,9]);
              translate([0, 0, 9]) {
                rotate([-150*(1-extend), 0, 0]) translate([0,-1,0]) cube([2,2,8]);
              }
            }
          }
          translate([3, 0, -1]) {
            rotate([170+80*extend, 20*extend, -10*extend]) {
              translate([0,-1,0]) cube([2,2,9]);
              translate([0, 0, 9]) {
                rotate([-150*(1-extend), 0, 0]) translate([0,-1,0]) cube([2,2,8]);
              }
            }
          }
        }
      }
    }
  }
}

function smoother_step(x) = x<0?0: x>1?1: 6*pow(x,5)-15*pow(x,4)+10*pow(x,3);
function smooth_speed(v) = (1-((1+(1-v)^2)/2)^0.5)/(2*(1-0.5^0.5));
function smooth_start(v) = 1-sin((1-v)*90);
rotate([0, 0, $t < 0.05 ? smooth_start($t/0.05)*0.05*360/0.825 : $t<0.8 ? 360*$t/0.825 : $t<0.85 ? (smooth_speed(($t-0.8)/0.05)*0.05+0.8)*360/0.825 : 0])
translate([100, 0, $t<0.85 ? 0 : $t < 0.96 ? 20*(1-(($t-0.905)/0.055)^2) : 0])
rotate([0, 0, $t<0.85 ? 0 : $t < 0.99 ? 3*360*($t-0.85)/0.14 : 0])
IceSkater(
  $t < 0.05 ? smoother_step(($t)/0.05) :
    1-smoother_step(($t-0.82)/0.03),
  $t < 0.88 ? 0.85*(1-smoother_step(($t-0.82)/0.05)) :
    0.85*smoother_step(($t-0.95)/0.05),
  $t < 0.83 ? smoother_step(($t-0.77)/0.06) :
    $t < 0.92 ? (1-smoother_step(($t-0.83)/0.04)) :
    0.5*(1-(($t-0.96)/0.04)^2)
);

