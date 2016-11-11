module AUI.DatGui.DUI where

import Prelude
import AUI.DatGui.DatGui (DatGui, DATGUI)
import Control.Apply (lift2)
import Control.Monad.Eff (Eff)
import Signal (Signal)

newtype DUI e a = DUI (DatGui -> Eff (datgui :: DATGUI | e) (Signal a))

instance functorDUI :: Functor (DUI e) where
  map f (DUI a) = DUI $ map (map (map f)) a

instance applyDUI :: Apply (DUI e) where
  apply (DUI a1) (DUI a2) = DUI $ lift2 xapply a1 a2 where
    xapply fn = apply (map apply fn)

instance applicativeDUI :: Applicative (DUI e) where
  pure x = DUI $ pure (pure (pure x))
