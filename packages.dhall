let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200911-2/packages.dhall sha256:872c06349ed9c8210be43982dc6466c2ca7c5c441129826bcb9bf3672938f16e

let overrides = {=}

let additions =
  { isomorphisms =
      { dependencies =
          [ "bifunctors"
          , "contravariant"
          , "control"
          , "distributive"
          , "either"
          , "foldable-traversable"
          , "identity"
          , "invariant"
          , "maybe"
          , "newtype"
          , "prelude"
          , "profunctor"
          , "tuples"
          ]
      , repo = "https://github.com/paf31/purescript-isomorphisms.git"
      , version = "v5.0.0"
      }
  , drawing =
      { dependencies =
          [ "canvas"
          , "lists"
          , "math"
          , "integers"
          , "colors"
          ]
      , repo ="https://github.com/paf31/purescript-drawing.git"
      , version = "v4.0.0"
      }
  , flare =
      { dependencies =
          [ "canvas"
          , "datetime"
          , "drawing"
          , "foldable-traversable"
          , "nonempty"
          , "prelude"
          , "signal"
          , "smolder"
          , "tuples"
          , "web-dom"
          ]
      , repo = "https://github.com/sharkdp/purescript-flare.git"
      , version = "v6.0.0"
      }
  }

in  upstream // overrides // additions
