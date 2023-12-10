#! /bin/sh
# Disneyland-style teacups
# Jordan Brown
# December 2023

# OpenSCAD Teacups by Jordan Brown is marked with
# CC0 1.0 Universal. To view a copy of this license,
# visit http://creativecommons.org/publicdomain/zero/1.0
# Translation:  Do with this what you like; no rights reserved.

# Be paranoid:  abort on any error.
set -e

# Point to a convenient copy of OpenSCAD
OPENSCAD=${OPENSCAD:-openscad}

# Prefix for PNG output files
out=teacups
# Frames per second and number of frames.  Make sure frames/fps is 15 seconds.
fps=20
frames=300
# Position the camera aimed a little to the left (not centered) and so some of the teacups
# rotate off the side.  That framing makes it a bit more interesting.
camera=-17,-20,0,70,0,30,300
# Compression parameter for creating .webp file.  0-100, 100 is high quality
compression=70

# Clean up from previous runs.
rm -f $out*.png

# Note that this overrides the fps and frames values set in the .scad file.
"$OPENSCAD" \
    -o $out.png \
    --imgsize 500,500 \
    --animate $frames \
    --colorscheme DeepOcean \
    --camera $camera \
    -D fps=$fps \
    -D frames=$frames \
    Teacups.scad

# You could also use this command to create an animated gif, but .webp is smaller.
# magick convert $out*.png -set delay $speed $out.gif

# Convert the PNG files into one .webp file.

(( ms_per_frame= 1000/$fps))
img2webp -v -loop 0 -d $ms_per_frame -lossy -q $compression -m 4 $out*.png -o $out.webp

# Finally, let's report how big the output file is.
ls -lh $out.webp
