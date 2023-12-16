// Porch Pirate
// Jordan Brown openscad@jordan.maileater.net
// December 2023

// Porch Pirate by Jordan Brown is marked with
// CC0 1.0 Universal. To view a copy of this license,
// visit http://creativecommons.org/publicdomain/zero/1.0
// Translation:  Do with this what you like; no rights reserved.

// A few parameters that are used in multiple places...

// Climb-out angle
climbA = 30;
// Cruising altitude
h = 50;

// Whether to include a time stamp in the display
timeStamp = false;

// The following is really the guts of the animation:  tables controlling
// positions, rotations, and a few other things about various components.
// the data varies a bit, but the common factor is that the the first
// entry in each element is a timestamp in seconds.

// A bit about time... OpenSCAD animation does not deal in real time.
// The animation clock always runs from 0 to 1.  Any relationship between
// that value and actual play time is through the cooperation of the
// OpenSCAD program, the animation settings (which control the maximum
// speed in the OpenSCAD user interface), and the settings passed to
// the post-processing PNG-to-video converter.  If you generate a
// thousand frames (because the animation parameters say to) and you
// feed them to a converter and tell it ten frames per second, you get
// a hundred seconds of video.  If you tell the converter twenty frames
// per second, that same thousand frames gets you fifty seconds of video.

// Here I don't specifically call out how many seconds the 0..1 animation
// will be.  Rather, a ways below I scan one of the arrays (I picked the
// vpd array, but I don't remember why) for minimum and maximum
// timestamps.  This slightly reduces the opportunity for mismatches,
// since there isn't a "total time" parameter that would need to match
// the arrays.  The arrays still need to match each other, though.
// Note that this technique also allows moving the start time negative,
// if I wanted to add something earlier without having to adjust all
// of the timestamps.

// Strictly, for values that are the same for the first few seconds
// (like the saucer rotation or the present location), or that are
// the same for the last few seconds (like all of the rotations),
// it isn't necessary to include that first (or last) entry, the T=0
// or T=30 entries.  The lookup function will use the first entry
// if the value looked up is smaller than that first entry's key,
// and the last entry if the value is larger than that last entry's key.
// However, I decided to always explicitly start at 0 and end at 30.

// Here's the time line of the video at a high level...
// 0     - Close-up of the present and tree (so that you can see that
//         it's a present, which is harder to see in long shots).
//         Saucer starts flying toward present.
// 4-5   - Zoom out.
// 5     - About now the saucer enters the frame.
//         This is not explicit; it's just whenever the saucer reaches
//         the frame.
// 9.5   - The pilot sees the present and slams on the brakes.
//         Saucer tips up, "?!?" bubble.
// 10-11 - Saucer stops, starts backing up.
// 13    - Saucer is over the present.  Pilot realizes what it is,
//         decides to steal it.  "!!!" bubble.
// 15-16 - Tractor beam extends.
// 17    - Saucer starts climb-out.
// 24-25 - Zoom back in to show no present and a mark on the ground
//         where it was.  Also puts us back in the original camera
//         position for the next loop of the video.  Some time before
//         the zoom-in, the saucer and present leave the frame.  Again,
//         this is not explicit.
// 30    - End

// Location of the saucer at various times.
// The saucer starts off-camera to the left (0), flies in (0-10),
// overshoots the present by a little (10-11), backs up (11-13),
// hovers over the present (13-17), and then climbs out off camera to
// the right (17-30).
saucerTranslate = [
    [0, [-300,0,h]],
    [10, [30,0,h]],
    [11, [30,0,h]],
    [13, [0,0,h]],
    [17, [0,0,h]],
    [30, [300,0,h+300*sin(climbA)]],
];
// Rotation of the saucer at various times.
// The saucer is level flying in from the left (0-9.5).  It tips
// up a bit as the pilot slams on the brakes (9.5-10), then back
// to level (10-10.5).  It remains level while returning to over
// the present and hovering (10.5-16.5), the rotates to the climb
// angle (16.5-17) and climbs out at that angle (17-30).
saucerRotate = [
    [0, [0,0,0]],
    [9.5, [0,0,0]],
    [10, [0,-10,0]],
    [10.5, [0,0,0]],
    [16.5, [0,0,0]],
    [17, [0,-climbA,0]],
    [30, [0,-climbA,0]],
];

// Location of the present.
// The present stands still until the saucer starts to climb out (0-17).
// It initially accelerates a little slower than the saucer (17-18),
// and then maintains a fixed position below and slightly behind the
// saucer during the climb-out (18-30).
presentTranslate = [
    [0, [0,0,0]],
    [17,[0,0,0]],
    [18,[15,0,13]],
    [30,[290,0,300*sin(climbA)]],
];
// Rotation of the present
// The present is upright until the saucer starts to climb out (0-17),
// then rotates to its new "being dragged" orientation (17-18), and
// remains at that orientation during the climb-out (18-30).
presentRotate = [
    [0, [0,0,0]],
    [17, [0,0,0]],
    [18, [0,10,0]],
    [30,[0,10,0]],
];

// Rotation of the tractor beam.
// It remains vertical until climb-out (0-17, but it's actually not
// present until 15, see tractorH), rotates to its "dragging" angle
// at the start of climb-out (17-18), and stays there for the climb-out
// (18-30).
tractorRotate = [
    [0, [0,0,0]],
    [17, [0,0,0]],
    [18, [0,10,0]],
    [30, [0,10,0]],
];

// Height of the tractor beam.
// A special-case check omits the tractor beam during times when it
// has zero height.
// It's omitted until the saucer is hovering over the package and
// the pilot has decided to steal it (0-15), extends down to the package
// (15-16), and remains at that size during the remainder and climb-out
// (16-30).
tractorH = [
    [0,0],
    [15,0],
    [16,h],
    [30,h],
];

// Center of the image.  We don't actually move this, but some drafts
// did and I left in the ability.
vpt = [
    [0, [2,11,14]],
    [30, [2,11,14]],
];

// Distance from the camera to the center - the zoom control.
// We start with a close-up of the present and tree (0-4), zoom out
// to a wider shot (4-5), watch the theft (5-24), zoom back in (24-25),
// and watch the empty space where the present was until the end (25-30).
vpd = [
    [0, 150],
    [4, 150],
    [5, 500],
    [24, 500],
    [25, 150],
    [30, 150],
];

// Camera rotation.  (I think this effectively controls the camera's
// position on the vpd-radius sphere around vpt.)
// During the initial close-up (0-4) we're looking down a little
// because that shows the shape of the present better, then during the
// zoom-out we go to a flatter view (4-5), maintain it during the theft
// (5-24), return to the original during the zoom-out (24-25), and
// maintain it until the end (25-30).
vpr = [
    [0, [80,0,10]],
    [4, [80,0,10]],
    [5, [85,0,5]],
    [24, [85,0,5]],
    [25, [80,0,10]],
    [30, [80,0,10]],
];

// I wanted to be able to easily tweak these for aesthetics, so I pulled
// them up here where they are convenient.
tractorColor = "Lime";
tractorAlpha = 0.25;    // Transparency.  0 is transparent, 1 is opaque.

// Set a fixed random seed (0) so that each frame gets the same set of
// random numbers, so that we can have components (e.g. the stars) that
// are random but don't vary from one frame to the next.  This technique
// does depend on each frame using the random numbers in the same way -
// if one frame used the first random number for one thing, and another
// used the first random number for a different thing, that would be bad.
junk = rands(0,0,0,0);

// Scan one of the arrays to determine the minimum and maximum
// timestamps.
astart = min([for (e = vpd) e[0] ]);
afini = max([ for (e = vpd) e[0] ]);
// Calculate the current timestamp, using $t as a fraction of the
// time between the start and end.
atime = astart + $t * (afini-astart);

// Calculate the camera parameters based on the tables above.
// Note that the a* functions and modules all use the "atime"
// calculated above.
$vpt = ainterp3(vpt);
$vpd = ainterp(vpd);
$vpr = ainterp3(vpr);

// The ground.
color("tan") translate([-150,-300,-0.01]) cube([300,400,0.01]);
// The patch of ground where the present was sitting.
// Note that this is there all the time, but only visible when the
// present moves away.
color("goldenrod") cube([10,10,0.01], center=true);

translate([10,10,0]) tree();

// Draw the present.
// atranslate interpolates a position according to the table supplied,
// and translates its child.  arotate does the same for rotation.
atranslate(presentTranslate) arotate(presentRotate) present(10);

// Draw the saucer and stuff that moves with it - the tractor beam
// and the thought bubbles.
atranslate(saucerTranslate) {
    // Draw the saucer.
    arotate(saucerRotate) flyingSaucer();
    // Draw the tractor beam.  Note that it doesn't draw itself
    // if the height is zero.
    arotate(tractorRotate) tractor(ainterp(tractorH));
    // Draw the thought bubbles at appropriate times.
    // Better would have been to have the times, text, and offset
    // specified in a table above.
    // The rotate($vpr) keeps the text facing the camera and keeps
    // its offset from the saucer left-right from the camera's
    // perspective; we could put the camera anywhere and the ?!?
    // would still appear above-left of the saucer and the !!!
    // above-right.
    // Center the text so that we can use the same offset to the
    // right as we do to the left, and everything still looks
    // symmetric.
    color("red") rotate($vpr) {
        if (atime > 9.5 && atime < 12) {
            translate([-20,10,0])
                linear_extrude(height=0.1)
                text("?!?", halign="center");
        }
        if (atime > 13 && atime < 15) {
            translate([20,10,0])
                linear_extrude(height=0.1)
                text("!!!", halign="center");
        }
    }
}

// Draw a mess of stars.  Put them a long ways away so they don't
// really move when we move the camera.  Unfortunately, the same is
// not true of the horizon; it's much closer and moves relative to
// the stars.  I messed around a bit with fixing that, but didn't like
// the result.  The problem is only really visible during the one-second
// zooms, so I decided to just leave it.  Note that there's a small
// variation in the size of the stars.
for (i=[0:400]) {
    color("white") translate([rands(-1500,500,1)[0], 4000, rands(-600,600,1)[0]]) cube(rands(2,5,1)[0]);
}

// Display the current time.
// This is not for the production video, but is helpful in setting
// times for various events.
// The rotate($vpd) scale($vpd/500) keep the text oriented the same
// way and at the same size as the camera moves.  There should probably
// be a translate($vpt) to keep it in the same position too, but we
// don't move the camera that way in this animation.
// The floor(atime*10)/10 limits the display to tenths of a second,
// but not very well since the fractional part disappears on integer
// seconds.
if (timeStamp) {
    rotate($vpr) scale($vpd/500) translate([0,80,0]) linear_extrude(height=0.1) text(str(floor(atime*10)/10));
}

// The villain itself!
module flyingSaucer() {
    r = 20;
    h = 7;
    cockpit = 5;
    bodyRatio = 0.5;
    cockpitRatio = 0.5;
    // The top and bottom of the saucer are the same, a segment of an
    // ellipsoid (a squashed sphere).  "bodyRatio" controls how squashed,
    // and "h" controls how much (measured from the top) we use.
    module halfSaucer() {
        difference() {
            translate([0,0,-r*bodyRatio + h])
                scale([1,1,bodyRatio])
                sphere(r=r);
            translate([-r*2, -r*2, -r*4]) cube(r*4);
        }
    }
    // Mirror the saucer vertically to form the bottom half.
    // render() it so that we only do the union once and then it's
    // cached.
    color("gray") render() {
        halfSaucer();
        mirror([0,0,1]) halfSaucer();
    }
    // The cockpit is similarly an ellipsoid, but we don't bother
    // cutting it up; we just hide the bottom part inside the saucer.
    color("white")
        translate([0,0,h])
        scale([1,1,cockpitRatio])
        sphere(r=cockpit);
}

// The present, a simple cube.  The module allows for
// non-cubes and different sizes.  My original thought was that
// there would be several presents of different shapes and colors,
// but it was tricky to see how to lay them out, and the story
// works fine with a single present.
module present(sz) {
    sz = is_list(sz) ? sz : [sz,sz,sz];
    color("royalblue") translate([-sz.x/2, -sz.y/2, 0]) cube(sz);
    translate([0, 0, sz.z]) bow(sz.x*0.7);
}

// Modeling-wise, the bow is actually the most complex thing in the
// animation.  Non-elipse curves are hard.  This makes one loop out
// of a single Bézier curve, offsets it in a little and subtracts
// to give it some thickness, makes a mirror copy, and then extrudes
// to turn it into a ribbon.  The result is not a very fancy bow,
// but it conveys the idea adequately.
module bow(sz) {
    points = [
        each bez([0,0], [1,0], [.3,.3], [0,0], 20)
    ];
    module halfBow() {
        difference() {
            polygon(points);
            offset(-0.01) polygon(points);
        }
    }
    color("red")
        rotate([90,0,0])
        linear_extrude(height=sz*0.2, center=true)
        scale(sz) {
            halfBow();
            mirror([1,0]) halfBow();
    }
}

// The tractor beam.
// Only create the tractor beam if it's got non-zero height; this is
// how it remains unshown until the right moment.
// This particular tractor beam, model HFD-348, maintains a constant
// diameter at its base as it extends to the target.  Other models,
// e.g. the -349, enlarge the diameter as the beam extends.
module tractor(h) {
    if (h > 0) {
        color(tractorColor, tractorAlpha)
            translate([0,0,-h])
            cylinder(h = h, d1 = 15, d2 = 1);
    }
}

// World's simplest Christmas tree.  Maybe it should have ornaments.
module tree() {
    color("green") translate([0,0,2]) cylinder(h=30, d1=12, d2=0);
    color("brown") cylinder(h=2, d=2);
}

// The rest of the file is general-purpose functions and modules not
// directly related to the objects in the animation.

// Bezier functions from https://www.thingiverse.com/thing:8443
// but that yielded either single points or a raft of triangles;
// this yields a vector of points that you can then concatenate
// with other pieces to form a single polygon.
// If we were really clever, I think it would be possible to
// automatically space the output points based on how linear
// the curve is at that point.  But right now I'm not that clever.
function BEZ03(u) = pow((1-u), 3);
function BEZ13(u) = 3*u*(pow((1-u),2));
function BEZ23(u) = 3*(pow(u,2))*(1-u);
function BEZ33(u) = pow(u,3);

function PointAlongBez4(p0, p1, p2, p3, u) = [
	BEZ03(u)*p0[0]+BEZ13(u)*p1[0]+BEZ23(u)*p2[0]+BEZ33(u)*p3[0],
	BEZ03(u)*p0[1]+BEZ13(u)*p1[1]+BEZ23(u)*p2[1]+BEZ33(u)*p3[1]];

// p0 - start point
// p1 - control point 1, line departs p0 headed this way
// p2 - control point 2, line arrives at p3 from this way
// p3 - end point
// segs - number of segments
function bez(p0, p1, p2, p3, segs) = [
    for (i = [0:segs]) PointAlongBez4(p0, p1, p2, p3, i/segs)
];

// Given a list, randomly pick one entry.
function randPick(list) = list[floor(rands(0,len(list),1)[0])];

// Given a value and a table of value/position pairs, interpolate a
// position for that value.
// It seems like lookup() should do this sort of vector interpolation
// on its own, but it doesn't seem to.
function xyzinterp(v, table) =
    let (x= [for (e = table) [e[0], e[1].x]])
    let (y= [for (e = table) [e[0], e[1].y]])
    let (z= [for (e = table) [e[0], e[1].z]])
        [lookup(v, x), lookup(v, y), lookup(v,z)];

// Given a table of animation time values and positions for each
// of those time values, translate the children to the appropriate
// position for the current time (in atime).
module atranslate(table) {
    translate(ainterp3(table)) children();
}

// Given a table of animation time values and rotations for each
// of those time values, rotate the children to the appropriate
// position for the current time (in atime).
module arotate(table) {
    rotate(ainterp3(table)) children();
}

// Given a table of animation time values and numeric values
// (with whatever semantics), interpolate the value for the
// current time (in atime).
function ainterp(table) = lookup(atime, table);

// Given a table of animation time values and XYZ values
// (with whatever semantics), interpolate the XYZ values for the
// current time (in atime).
function ainterp3(table) = xyzinterp(atime, table);
