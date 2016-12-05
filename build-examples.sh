OUT="output"

mkdir -p $OUT

pulp browserify -I test --main AUI.Flare.Examples --to $OUT/flare-examples.js
pulp browserify -I test --main AUI.DatGui.Examples --to $OUT/datgui-examples.js
