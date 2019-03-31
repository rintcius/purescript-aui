module AUI.DatGui.DatGui where

import AUI.AUI as A
import Effect (Effect)
import Signal (Signal)

foreign import data DatGui :: Type

foreign import mkDatGui :: Effect DatGui
foreign import addToGui :: forall a. A.Label -> a -> DatGui -> Effect (Signal a)
foreign import addNumberToGui :: forall a. A.Label -> a -> Number -> Number -> Number -> DatGui -> Effect (Signal a)
foreign import addIntToGui :: forall a. A.Label -> a -> Int -> Int -> DatGui -> Effect (Signal a)
foreign import addOutputToGui :: forall a. A.Label -> Signal a -> DatGui -> Effect (Signal a)
foreign import addButtonToGui :: forall a. A.Label -> a -> a -> DatGui -> Effect (Signal a)
foreign import addSelectToGui :: forall a. A.Label -> a -> Array a -> (a -> String) -> DatGui -> Effect (Signal a)
