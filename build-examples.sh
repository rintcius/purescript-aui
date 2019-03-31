OUT="output"

mkdir -p $OUT

spago bundle --main AUI.Flare.Examples --to $OUT/flare-examples.js
spago bundle --main AUI.DatGui.Examples --to $OUT/datgui-examples.js
