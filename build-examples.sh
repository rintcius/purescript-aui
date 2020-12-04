OUT="output"

mkdir -p $OUT

spago bundle-app --main AUI.Flare.Examples --to $OUT/flare-examples.js
spago bundle-app --main AUI.DatGui.Examples --to $OUT/datgui-examples.js
