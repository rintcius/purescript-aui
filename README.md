# AUI

## Description

`purescript-aui` (Algebraic User Interface) is a library written in Purescript
for specifying and showing (parts of) UI's.

This library firstly provides a DSL that allows you to *specify* a UI.
Next, it provides interpreters that take care of showing these UI's.

Currently 2 interpreters have been implemented, one showing the UI using
[Flare](https://github.com/sharkdp/purescript-flare/)
and the other one showing it using [dat.GUI](https://github.com/dataarts/dat.gui).

## Examples

The examples are derived from [these Flare examples](http://sharkdp.github.io/purescript-flare/).

* [specification of these examples](https://github.com/rintcius/purescript-aui/blob/master/test/AUI/Examples.purs)
* [Flare interpretation](https://github.com/rintcius/purescript-aui/blob/master/test/AUI/Flare/Examples.purs)
* [dat.GUI interpretation](https://github.com/rintcius/purescript-aui/blob/master/test/AUI/DatGui/Examples.purs)

## Build

```
bower install

pulp browserify -O -I test --main AUI.Flare.Examples --to output/flare-examples.js
pulp browserify -O -I test --main AUI.DatGui.Examples --to output/datgui-examples.js

open resources/*.html
```

## Thanks!

Thanks to all developers of the `purescript` libs that this lib depends on.
Apart from the core PS stuff, in particular `purescript-flare`, `purescript-freeap`
and `purescript-signal` are a joy to depend on.

Finally, this lib is still very much an experiment at this stage
and I'd be happy to receive feedback.
