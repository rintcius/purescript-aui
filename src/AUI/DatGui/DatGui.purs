module AUI.DatGui.DatGui where

import AUI.AUI as A
import Control.Monad.Eff (Eff)
import Signal (Signal)

foreign import data DATGUI :: !
foreign import data DatGui :: *

foreign import mkDatGui :: forall e. Eff (datgui :: DATGUI | e) DatGui
foreign import addToGui :: forall a e. A.Label -> a -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
foreign import addNumberToGui :: forall a e. A.Label -> a -> Number -> Number -> Number -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
foreign import addIntToGui :: forall a e. A.Label -> a -> Int -> Int -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
foreign import addOutputToGui :: forall a e. A.Label -> Signal a -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
foreign import addButtonToGui :: forall a e. A.Label -> a -> a -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
foreign import addSelectToGui :: forall a e. A.Label -> a -> Array a -> (a -> String) -> DatGui -> Eff (datgui :: DATGUI | e) (Signal a)
