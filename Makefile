
PROJECT=breakout-alt-165
SCHEMATIC_X=schematic
LAYOUT_X=layout
LAYOUT_TOP_X=$(LAYOUT_X)-top
LAYOUT_BOTTOM_X=$(LAYOUT_X)-bottom
BUILD=build
PDF_PRODUCTS = $(SCHEMATIC_X).pdf $(LAYOUT_X).pdf
PNG_PRODUCTS = $(SCHEMATIC_X).png $(LAYOUT_TOP_X).png $(LAYOUT_BOTTOM_X).png
DISPLAY_PRODUCTS = $(PNG_PRODUCTS)

default: $(DISPLAY_PRODUCTS)

$(BUILD):
	mkdir -p build

distclean: clean
	rm -vf $(DISPLAY_PRODUCTS)

clean:
	rm -rvf $(BUILD)

$(SCHEMATIC_X).pdf: $(BUILD)/schematic.pdf
	cp $^ $@

$(LAYOUT_X).pdf: $(BUILD)/layout.pdf
	cp $^ $@

$(SCHEMATIC_X).png: $(BUILD)/schematic.png
	cp $^ $@

$(LAYOUT_TOP_X).png: $(BUILD)/layout-top.png
	cp $^ $@

$(LAYOUT_BOTTOM_X).png: $(BUILD)/layout-bottom.png
	cp $^ $@




$(BUILD)/schematic.pdf: $(PROJECT).sch | $(BUILD)
	gaf export -o $@ $^

$(BUILD)/schematic.png: $(BUILD)/schematic.pdf | $(BUILD)
	convert -density 200x200 $^ -scale 40% $@

$(BUILD)/layout.ps: $(PROJECT).pcb | $(BUILD)
	pcb -x ps --psfile $@ $^

$(BUILD)/layout.pdf: $(BUILD)/layout.ps | $(BUILD)
	ps2pdf $^ $@

$(BUILD)/layout-top.eps: $(PROJECT).pcb | $(BUILD)
	pcb -x eps --layer-stack "outline,top,silk" --layer-color-1 '#000088' --element-color '#FFFFFF' --as-shown --eps-file $@ $^

$(BUILD)/layout-bottom.eps: $(PROJECT).pcb | $(BUILD)
	pcb -x eps --layer-stack "outline,bottom,silk,solderside" --layer-color-2 '#000088' --element-color '#FFFFFF' --as-shown --eps-file $@ $^

$(BUILD)/layout-top.png: $(BUILD)/layout-top.eps | $(BUILD)
	convert -density 600x600 $^ -background '#4444ff' -flatten $@

$(BUILD)/layout-bottom.png: $(BUILD)/layout-bottom.eps | $(BUILD)
	convert -density 600x600 $^ -background '#4444ff' -flatten $@

