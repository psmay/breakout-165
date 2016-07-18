#!/bin/sh
EPS1="$1"
EPS2="$2"
PNGOUT="$3"

BG="#4444ff"
DENSITY="600x600"
WORK="`mktemp -d`" || exit 1

convert \
	-background "$BG" \
	-density "$DENSITY" "$EPS1" -flatten \
	-density "$DENSITY" "$EPS2" -flatten \
	-bordercolor "$BG" -border 1x1 \
	"$WORK/tmp.png" &&
convert \
	"$WORK/tmp.png" \
	-bordercolor "$BG" \
	-trim \
	"$PNGOUT"

rm -rf "$WORK"
