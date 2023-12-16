#! /bin/sh
# Porch Pirate
# Jordan Brown openscad@jordan.maileater.net
# December 2023

# Porch Pirate by Jordan Brown is marked with
# CC0 1.0 Universal. To view a copy of this license,
# visit http://creativecommons.org/publicdomain/zero/1.0
# Translation:  Do with this what you like; no rights reserved.

# Let the user watch what we're doing.
set -x

# Be paranoid:  abort on any error.
set -e

# Point to a convenient copy of OpenSCAD, or on $PATH.
OPENSCAD="openscad"

# Name of SCAD file.
in="Porch Pirate"
# Prefix for PNG output files, and name for resulting video files.
out="Porch Pirate"
# Directory for PNG files.  You could make this be ".", but it would add clutter in the
# directory where you are keeping your source files.
outdir=out
# Length in seconds - must match the .scad file.
length=30
# Frames per second.  This can be whatever you like, within quality/size/performance limits.
fps=20
# Compression parameter for creating .webp file.  0-100, 100 is high quality.
# This is a really simple video; high quality doesn't cost much size.
compression=100

# Calculate the number of frames.
(( frames = $fps * $length))

mkdir -p "$outdir"
# Clean up from previous runs.
rm -f "$outdir/$out"*.png

"$OPENSCAD" \
    -o "$outdir/$out.png" \
    --imgsize 500,500 \
    --animate $frames \
    --colorscheme DeepOcean \
    "$in.scad"

# Create both an animated GIF (for imgur) and a WEBP (for the calendar).

# Convert the PNG files into one .gif file.
magick convert "$outdir/$out"*.png -set delay 1x$fps "$out.gif"

# Convert the PNG files into one .webp file.
(( ms_per_frame= 1000/$fps))
img2webp             \
    -v               \
    -loop 0          \
    -d $ms_per_frame \
    -lossy           \
    -q $compression  \
    -m 4             \
    -o "$out.webp"   \
    "$outdir/$out"*.png

# Finally, let's report how big the output files are.
ls -lh "$out.webp" "$out.gif"
