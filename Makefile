SUFFIX0:=
SUFFIX1:=1
SUFFIX2:=2

define define_compile_rules
$(1)/%$(SUFFIX$(2)).3mf : $(1)/%.scad
	$$(O) $$< -o $$@ --quiet --enable manifold \
		$$($$(@F)_FLAGS)
$(1)/%$(SUFFIX$(2)).png : $(1)/%.scad
	$$(O) $$< -o $$@ --quiet --colorscheme DeepOcean --view axes,scales \
		--camera $$(if $$(strip $$($$(@F)_CAMERA)),$$($$(@F)_CAMERA),$$(CAMERA)) \
		--imgsize $$(if $$(strip $$($$(@F)_WIDTH)),$$($$(@F)_WIDTH),$$(WIDTH)),$$(HEIGHT) \
		$$($$(@F)_FLAGS)
endef

$(foreach directory,\
	$(shell find . -mindepth 1 -maxdepth 1 -type d),\
	$(foreach suffix,0 1 2,$(eval $(call define_compile_rules,$(directory),$(suffix)))))

O  := openscad-nightly
WIDTH  := 1600
HEIGHT := 1600
CAMERA := 0,0,0,55,0,25,150

.PHONY: all
all: \
	Twist/Twist1.png \
	Twist/Twist2.png \
	Twist/Twist.png \
	Twist/Twist1.3mf \
	Twist/Twist2.3mf \
	GiftCannon/GiftCannon.png

Twist/Twist.png : Twist/Twist1.png Twist/Twist2.png
	gm convert +append $^ $@

Twist1.3mf_FLAGS=-DInsideCone=false

Twist2.3mf_FLAGS=-DInsideCone=true

Twist1.png_WIDTH=800
Twist1.png_FLAGS=-DInsideCone=false
Twist1.png_CAMERA=-10,0,0,80,0,40,500

Twist2.png_WIDTH=800
Twist2.png_FLAGS=-DInsideCone=true
Twist2.png_CAMERA=10,0,0,80,0,40,500

GiftCannon.png_CAMERA=8,0,4,70,0,20,110

