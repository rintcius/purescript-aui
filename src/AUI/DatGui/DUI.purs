module AUI.DatGui.DUI where

import Prelude

import AUI.DatGui.DatGui (DatGui)
import Control.Apply (lift2)
import Effect (Effect)
import Signal (Signal)

newtype DUI e a = DUI (DatGui -> Effect (Signal a))

instance functorDUI :: Functor (DUI e) where
  map f (DUI a) = DUI $ map (map (map f)) a

instance applyDUI :: Apply (DUI e) where
  apply (DUI a1) (DUI a2) = DUI $ lift2 xapply a1 a2 where
    xapply fn = apply (map apply fn)

instance applicativeDUI :: Applicative (DUI e) where
  pure x = DUI $ pure (pure (pure x))
