// Christmas Cannon by Lee Fallat (inbox@leefallat.ca) is marked with CC0 1.0. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

cannon_height = 20;
cannon_radius = 2.5;
taper = 1.5;

stick_radius = 0.33; // to place a stick inside to hold the present

inner_height = cannon_height / 3;

module present() {
        translate([0, 0, 2.5 + 0.5])
        scale([1, 1, 0.75])
        sphere(1, $fn=30);
    
        for(i = [0 : 90 : 360]) {
            translate([0, 0, 2.5 + 0.5])
            rotate([0, -25, i])
            translate([1.5, 0, 0])
            scale([1, 1.33, 0.5])
            difference() {
                sphere(1, $fn=30);
                rotate([0, 90, 90])
                cylinder(3, r=0.7, $fn=20, center=true);
            }
        }
    
        minkowski() {
            cube(5, center=true);
            sphere(0.5, $fn=20);
        }
}

module cannon() {
    translate([-cannon_height / 2.5, 0, 0])
    union() {
        difference() {
            
                rotate([0, 90, 0])
                rotate_extrude($fn=30)
                rotate([0, 0, 90])
                polygon([
                    [0,0],
                    [0,cannon_radius * 1.25],
                    [cannon_height / 15, cannon_radius * 1.25],
                    [cannon_height / 15, cannon_radius],
                    [cannon_height - cannon_height / 10, cannon_radius / taper],
                     [cannon_height - cannon_height / 10, cannon_radius * 1.1 / taper],
                    [cannon_height - (cannon_height / 10) / 1.5, cannon_radius * 1.1 / taper],
                    [cannon_height - (cannon_height / 10) / 1.5, cannon_radius / taper],
                    [cannon_height, cannon_radius / taper],
                    [cannon_height, 0]
                ]);

             
            
            translate([cannon_height / 2 + inner_height / 2 + 0.25 + 0.0001, 0, 0])
            rotate([0, 90, 0])
            cylinder(cannon_height / 3, r=cannon_radius / taper / 1.33, $fn=30);
           
        }
        
        rotate([0, 90, 0])
        cylinder(cannon_height * 1.5, r=stick_radius, $fn=30);
        

        translate([30, 0, 0])
        rotate([45, 45, 0])
        present();

        translate([cannon_height - 0.25 + 0.25, 0, 0])
        rotate([0, 90, 0])
        rotate_extrude($fn=30)
        translate([cannon_radius - 0.5, 0, 0])
        circle(0.5);

        sphere(cannon_radius * 1.0, $fn=30);

        translate([cannon_height / 2.5, 0, 0])
        rotate([90, 0, 0])
        cylinder(wheel_space, r = 0.6, $fn=15, center=true);
    }
};

wheel_space = 9.5;
wheel_thickness = 1.0;
wheel_radius = 5;
wheel_radius2 = wheel_radius / 1.125;
wheel_spokes = 12;

module wheel() {
    rotate([90, 0, 0])
    union() {
        difference() {
            cylinder(wheel_thickness, r = wheel_radius, $fn=60, center=true);
            cylinder(wheel_thickness + 0.001, r = wheel_radius2, $fn=60, center=true);
        }
        cylinder(wheel_thickness, r=2, center=true);
        for(i = [1 : 1 : wheel_spokes]) {
            rotate([0, 0, 360 / wheel_spokes * i])
            rotate([0, 90, 0])
            cylinder(wheel_radius - (wheel_radius - wheel_radius2), r=0.2, $fn=15);
        }
    };
}
    
rotate([0, -25, 0]) cannon();
translate([0, wheel_space / 2, 0]) wheel();
translate([0, -wheel_space / 2, 0]) wheel();

