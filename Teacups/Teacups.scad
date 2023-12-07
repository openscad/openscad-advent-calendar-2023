// Disneyland-style teacups
// Jordan Brown
// December 2023

// OpenSCAD Teacups by Jordan Brown is marked with
// CC0 1.0 Universal. To view a copy of this license,
// visit http://creativecommons.org/publicdomain/zero/1.0
// Translation:  Do with this what you like; no rights reserved.

// First, a bunch of parameters.  There are two basic styles for OpenSCAD
// programs:  putting all of the parameters of the model up front like this,
// or "hiding" them in each component so that it is difficult to accidentally
// depend on another component's parameters.  For this model I've put the
// parameters up front so that I can play with them to tweak the presentation,
// without getting into the details of the model's construction.
// Although these parameters are not really designed for customization, they
// *are* visible to the customizer and customization will sort of work.

// For more information on what these parameters mean, see the modules that
// use them.

/* [Circle quality] */
// Sets the minimum angle for segments of a circle.  Large circles will not have segments smaller than this.
$fa = 2;
// Sets the minimum size for segments of a circle.  Small circles will not have segments smaller than this.
$fs = 0.5;

/* [Camera] */
// Camera settings.  Probably these should be removed for release, but for now I want them here to make it easier to tweak the settings in the mkvideo script.
//$vpt = [-17,-20,0];
//$vpr = [70,0,30];
//$vpd = 300;
//$vpf = 22;

/* [Teacup dimensions] */
// Height of the half-ellipsoid that the teacup is made from
teacupH1 = 13;
// How much of the half-ellipsoid will be used, measured from the equator down
teacupH2 = 12.5;
// Radius of the teacup's rim, the equator of the ellipsoid
teacupR = 10;
// Thickness of the teacup.  This is only an approximation because it is scaled by the ellipse ratio, so the teacup is thicker at the bottom than on the sides.
teacupT = 0.2;
// Height of the trim color around the rim of the teacup
teacupTrimH = 1;

/* [Teacup handle dimensions] */
// Minor radius of the handle torus
handleR1 = 1;
// Major radius of the handle torus
handleR2 = 3;
// Angular size of the handle torus
handleA = 207;
// How far to lift the handle
handleH = 8.5;
// Replacement $fs for the torus cross-section, because the default above is visually poor for this size object.
handleR1fs = $fs/2;

/* [Saucer dimensions] */
// Radius at the bottom
saucerR1 = 8;
// Radius at the top
saucerR2 = 13;
// Thickness in the middle
saucerT = 1;
// Height of the saucer at the edge
saucerH = 1.5;
// Radius of the trim ring
saucerTrimR = 1;

/* [Main plate] */
// Radius
plateR = 100;
// Radius at which subplates are centered
plateR2 = 57;
// Color
plateColor = "blueviolet";
// Number of subplates
nSubplate = 3;

/* [Subplate] */
// Radius
subplateR = 40;
// Radius at which teacups are centered
subplateR2 = 35;
// Color
subplateColor = "purple";
// Number of teacups per subplate
nTeacup = 6;

/* [People] */
// Body dimensions
personBodyDims = [5,3,8];
// Arm dimensions (both upper and forearm)
personArmDims = [1,1,5];
// Neck radius
personNeckR = 1;
// Neck height
personNeckH = 1;
// Head radius
personHeadR = 1.5;
// Color; default to OpenSCAD yellow regardless of color scheme
personColor = "#f9d72c";

/* [Speeds and animation] */
// Maximum teacup speed.  0 has the teacup not spin; it just turns with the subplate and plate.  1 has it spin once during the full cycle; 2 has it spin twice, et cetera.  The speed for each teacup is random; see teacupSpeed().
maxTeacupSpeed = 4;
// The plate speed, in degrees per second.  Ensure that this matches up with frames/fps so that it returns to the starting point at the end.
plateSpeed = 24;
// The subplate speed, in degrees per second.  Negative means that they spin clockwise.  Again, ensure that this matches up with frames/fps.
subplateSpeed = -48;

// These control our translation from $t back to seconds.  OpenSCAD animation
// can't keep up this frame rate, but it lets us interactively check that the
// start image matches the end image so that we can loop seamlessly.  When
// creating the final animation, these parameters are overridden by the shell
// script.

// Frames per second.  10 is a bit choppy; 20 is good.
fps = 10;
// Total number of frames: 15 seconds per rotation, estimated from Disneyland video.  
frames = 150;

// Nothing below here is customizable.
module stopCustomizer();

// Teacup color schemes.  For each pair, the first value is the body color
// and the second value is the trim color.
teacupColors = [
    ["pink", "deeppink"],
    ["palegoldenrod", "sandybrown"],
    ["palegreen", "lime"],
    ["salmon", "red"],
    ["lavender", "violet"],
    ["skyblue", "blue"],
];

// Colors of people's shirts.
personShirtColors = [
    "lavender",
    "plum",
    "orchid",
    "magenta",
    "mediumPurple",
    "blueviolet",
    "darkorchid",
    "purple",
    "darkslateblue",
    "mediumslateblue",
    "indianred",
    "salmon",
    "lightsalmon",
    "crimson",
    "darkred",
    "aqua",
    "lightcyan",
    "turquoise",
    "steelblue",
    "lightblue",
    "deepskyblue",
    "royalblue",
    "mediumblue",
    "navy",
    "midnightblue",
    "pink",
    "hotpink",
    "mediumvioletred",
    "greenyellow",
    "lime",
    "lightgreen",
    "mediumseagreen",
    "green",
    "olivedrab",
    "darkolivegreen",
    "teal",
    "lightsalmon",
    "tomato",
    "orange",
    "gold",
    "darkkhaki",
    "burlywood",
    "rosybrown",
    "sandybrown",
    "darkgoldenrod",
    "chocolate",
    "sienna",
    "brown",
    "maroon",
    "lightgrey",
    "darkgray",
    "gray",
    "slategray",
    "black",
];

// Distribution of party size.  Favor two.  Allow but disfavor one and zero.
parties = [ 0, 1, 2, 2, 2, 2, 3, 3 ];

// Calculate some timing parameters.

// Total number of seconds for the animation
totalSec = frames/fps;
// Time in seconds since start of animation.  All of the positions are calculated based on this.
sec = $t*totalSec;

// A general-purpose utility function:  given a list, randomly pick one entry.
function randPick(list) = list[floor(rands(0,len(list),1)[0])];

// Some functions that pick values that differ from one teacup to another.

// Teacup speed.  Randomly pick speed for a teacup, in terms of the number
// of times that it will spin during the full animation, so that it will return
// to its start point at the end.
function teacupSpeed() = -360/totalSec*floor(rands(0,maxTeacupSpeed+1,1)[0]);
// Randomly pick a start angle for a teacup.
function teacupStart() = rands(0,360,1)[0];
// Assign teacup color schemes, rotating through the available schemes.
// You might think of i as a "global teacup number", ranging from zero to
// the total number of teacups.
function teacupColor(subplate, teacup) =
    let (i = subplate*nTeacup + teacup - nTeacup - 1)
    teacupColors[i % len(teacupColors)];
// Randomly pick the number of people in a teacup.  See the table above;
// values range from 0 to 3 but are not uniformly distributed.  Real
// Disneyland teacups seat up to five, but I thought that was too crowded.
function teacupNPeople() = floor(randPick(parties));

// Set a constant seed for the random numbers.  This means that every run
// of the program will get the same sequence of random numbers.  Remember that
// OpenSCAD animation runs the program repeatedly, varying $t from one
// run to the next.  A constant random number seed means that every frame
// gets the same series of random numbers and so the "random" selections for
// the teacups are the same from one frame to the next.
junk = rands(0,0,0,0);

// Finally, some geometry!

// Create a teacup in the specified color scheme (body, trim).
// Takes a person as a child.
module teacup(colorScheme) {
    // First, make the body of the teacup.
    // render() it so that the difference and intersections are computed once
    // and cached.
    // The teacups are a half-ellipsoid, an asymmetrically-scaled sphere,
    // cut in half, with the bottom cut off, with the center scooped out.
    color(colorScheme[0]) render() difference() {
        // The outside of the body, an ellipsoid intersected with a cube
        // that chops out the part that we want.  Note that teacupR*3
        // yields a cube that is larger in X and Y than the ellipsoid (which
        // has a radius of teacupR).
        intersection() {
            // Put the equator of the ellipsoid at the desired final height.
            translate([0,0,teacupH2]) scale([1,1,teacupH1/teacupR]) sphere(r=teacupR);
            translate([0,0,teacupH2/2]) cube([teacupR*3,teacupR*3,teacupH2], center=true);
        }
        // The inside of the teacup, constructed similarly.  Note that the
        // original sphere is a little smaller, and that it's lifted up
        // a little.
        intersection() {
            translate([0,0,teacupH2]) scale([1,1,teacupH1/teacupR]) sphere(r=teacupR-teacupT);
            translate([0,0,teacupH2/2+teacupT]) cube([teacupR*3,teacupR*3,teacupH2], center=true);
        }
    }

    // Build the trim and the handle.
    color(colorScheme[1]) render() {
        // Handle.  It's a portion of a torus, rotated and lifted into place.
        // The parameters above were hand-tweaked to get it into the right place
        // and ensure that the bottom touches the teacup but does not penetrate
        // into the interior.  Note that at the top the teacup sides are close
        // enough to vertical that we can pretend they are.
        translate([teacupR-teacupT,0,handleH]) rotate([90,0,0]) rotate(90-handleA)
            rotate_extrude(angle=handleA)
            translate([handleR2,0,0]) circle(handleR1, $fs=handleR1fs);
        // "Paint" some trim onto the rim, extruding a hollow cylinder just
        // a tiny bit thicker than the teacup and extending a tiny bit above it.
        translate([0,0,teacupH2-teacupTrimH+0.1])
            linear_extrude(height=teacupTrimH) difference() {
                circle(r=teacupR+0.01);
                circle(r=teacupR-teacupT-0.1);
        }
    }
    
    // Place people in the teacup
    // Number of people
    nPeople = teacupNPeople();
    // Pick a random angle for the first person.  (Actually, for the last
    // person, since we don't use person zero; we count from 1 to n.)
    personZeroAngle = rands(0,360,1)[0];
    // Note that the :1: in the middle of this range is necessary; nPeople
    // will sometimes be zero and [1:0] yields 0 and 1, not no entries.
    for (i=[1:1:nPeople]) {
        // Translate the person out to a hand-tweaked position, and rotate
        // them into their seat.  Note that people are defined so that their
        // back is at Y=0 and they face -Y, into the default camera, so we
        // push them +Y (before rotating) until their backs are almost
        // against the side of the teacup.
        // For no particular reason, we have the caller give us a person as
        // a child, rather than knowing here that we should call person().
        rotate(i*360/nPeople + personZeroAngle)
            translate([0,teacupR*0.9,teacupH2*0.6])
            children();
    }
}

// Build a saucer using the specified color scheme (body, trim)
// Takes a teacup as a child.
module saucer(colorScheme) {
    // Build the body of the saucer by subtract one very short truncated cone
    // from another.
    color(colorScheme[0]) render() difference() {
        cylinder(h=saucerH, r1=saucerR1, r2 = saucerR2);
        translate([0,0,saucerT]) cylinder(h=saucerH, r1=saucerR1, r2 = saucerR2);
    }
    // "Paint" a trim ring around the outside of the saucer.
    color(colorScheme[1]) render()
        translate([0,0,saucerH])
        linear_extrude(height=0.1)
        difference() {
            circle(r=saucerR2);
            circle(r=saucerR2 - saucerTrimR);
    }
    // Place the child (presumably a teacup) in the center, on top of the saucer.
    translate([0,0,saucerT]) children(0);
}

// Build a person.  We only build a torso, neck, head, and arms.  Our people
// have no legs.  Good thing they spend their entire existence sitting in
// a teacup.
// [0,0,0] is
//     X:  the left-right center
//     Y:  the back of the torso
//     Z:  the bottom of the torso
// The person faces into -Y.  (This means that with the default camera, they
// are more or less facing into the camera.)
module person() {
    // Build a torso.  The first child is a neck; the second child is an arm.
    module body() {
        // Make the body out of an elliptical cylinder.  This is not only a
        // tiny bit more realistic but also avoids flashing effects that you
        // get when a rotating cube passes some key lighting angles.
        // Pick a "shirt" color at random.
        translate([0, -personBodyDims.y/2, 0])
            color(randPick(personShirtColors))
            scale([1, personBodyDims.y/personBodyDims.x, 1])
                cylinder(h=personBodyDims.z, d=personBodyDims.x);
        // Place the subcomponents
        color(personColor) {
            // Put the neck centered above the torso.
            translate([0, -personBodyDims.y/2, personBodyDims.z]) children(0);
            // Put one arm on the +X side, with its top at the top of the torso.
            translate([personBodyDims.x/2, -personBodyDims.y/2, personBodyDims.z])
                children(1);
            // Take another and mirror it to the -X side.
            mirror([1,0,0])
                translate([personBodyDims.x/2, -personBodyDims.y/2, personBodyDims.z])
                children(1);
        }
    }
    // Create a neck, and put its child, a head, on top of it.
    module neck() {
        cylinder(h=personNeckH, r=personNeckR);
        translate([0,0,personNeckH]) children(0);
    }
    // Create a head.  Lift it up most of its radius, so that a small amount
    // of the sphere will extend into -Z and merge with the neck.
    module head() {
        translate([0,0,personHeadR*0.8]) sphere(r=personHeadR);
    }
    // One arm.  Note that the forearm is identical to the upper arm,
    // just oriented horizontally.
    // [0,0,0] is the inside top of the upper arm, centered forward and backward.
    // It extends out into +X, forward and back into +/-Y, and down into -Z.
    module arm() {
        translate([0,-personArmDims.y/2,-personArmDims.z]) cube(personArmDims);
        // The forearm is the same dimensions as the upper arm, located
        // to overlap the bottom of the upper arm, and extending out into -Y.
        translate([0,personArmDims.y/2-personArmDims.z,-personArmDims.z])
            cube([personArmDims.x,personArmDims.z,personArmDims.y]);
    }
    // Construct the entire person, using the "children" mechanism to attach
    // a head to a neck, and then the head-neck assembly and an arm to the body.
    // This could equally well have been done by having body() know that it needs
    // to attach a neck() and arm()s, but this scheme allows for creating some
    // people with tentacles, with two heads, et cetera, using the same body.
    body() {
        neck() head();
        arm();
    }
}

// Build a teacup set:  saucer, teacup, and people.  Use the specified color
// scheme (body, trim).  Note that the saucer places its child teacup, and
// the teacup places zero or more of its child people.
module set(colorScheme) {
    saucer(colorScheme)
        teacup(colorScheme)
        person();
}
// Construct the big plate, adding subplates onto it.  Rotate each subplate
// as appropriate for the animation.  Note that our caller is responsible for
// rotating the plate.
module plate() {
    plateT = 0.1;
    color(plateColor) cylinder(h=0.1, r=plateR);
    translate([0,0,plateT]) for (i=[1:nSubplate]) {
        rotate(i*360/nSubplate) translate([plateR2,0,0])
            rotate(sec*subplateSpeed) subplate(i);
    }
}

// Construct one subplate.  "i" is the number of the subplate, 1..n.
// Place the teacup sets, rotating each as appropriate for the animation.
module subplate(i) {
    color(subplateColor) cylinder(h=0.1, r=subplateR);
    for (j=[1:nTeacup]) {
        rotate(j*360/nTeacup)
            translate([subplateR2,0,0])
            rotate(sec*teacupSpeed() + teacupStart()) set(teacupColor(i, j));
    }
}

// Finally, we actually do something.  Create the plate and rotate it as
// appropriate for the animation.
rotate(sec*plateSpeed) plate();
