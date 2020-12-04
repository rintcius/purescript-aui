{ sources = [ "src/**/*.purs", "test/**/*.purs" ]
, name = "purescript-aui"
, dependencies =
  [ "console"
  , "effect"
  , "flare"
  , "freeap"
  , "isomorphisms"
  , "lists"
  , "prelude"
  , "signal"
  ]
, packages = ./packages.dhall
}
