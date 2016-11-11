module AUI.DatGui.Interpreter where

import Prelude
import AUI.AUI as A
import AUI.DatGui.DatGui as D
import AUI.FreeApAUI as FA
import AUI.DatGui.DUI (DUI(DUI))
import Control.Applicative.Free (foldFreeAp)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception.Unsafe (unsafeThrow)
import Data.Array (fromFoldable)
import Signal (runSignal, Signal, (~>))

toUI :: forall e. A.AUI ~> DUI e
toUI (A.NumberField l v f) = DUI $ D.addToGui l (f v)
toUI (A.IntField l v f) = DUI $ D.addToGui l (f v)
toUI (A.StringField l v f) = DUI $ D.addToGui l (f v)
toUI (A.Checkbox l (A.CheckboxState v)) = DUI $ xxx <$> D.addToGui l (toBoolean v) where
  toBoolean { status : A.Checked } = true
  toBoolean { status : A.Unchecked } = false
  toStatus true = A.Checked
  toStatus false = A.Unchecked
  toA b = A.selectedCheckbox (A.CheckboxState (v { status = toStatus b }))
  --TODO why does it give an error if this is inlined above?
  xxx = map (map toA)
toUI (A.Button l (A.ButtonState v)) = DUI $ D.addButtonToGui l v.up v.down
toUI (A.Selectbox l (A.Select s r toString)) = DUI $ D.addSelectToGui l s (fromFoldable r) toString
toUI (A.OutputField l s) = DUI $ D.addOutputToGui l s
toUI _ = unsafeThrow "TODO"

run :: forall a e. FA.FAUI a -> DUI e a
run (FA.FAUI c) = foldFreeAp toUI c

applyGui :: forall a e. D.DatGui -> DUI e a -> Eff (datgui :: D.DATGUI | e) (Signal a)
applyGui gui (DUI dg) = dg gui

build :: forall a e. FA.FAUI a -> D.DatGui -> Eff (datgui :: D.DATGUI | e) (Signal a)
build faui gui = applyGui gui (run faui)

buildNew :: forall a e. FA.FAUI a -> Eff (datgui :: D.DATGUI | e) (Signal a)
buildNew faui = D.mkDatGui >>= build faui

runNew :: forall a e. FA.FAUI a -> (a -> Eff (datgui :: D.DATGUI | e) Unit) -> Eff (datgui :: D.DATGUI | e) Unit
runNew faui x = buildNew faui >>= (\sig -> runSignal (map x sig))

bindNew :: forall a e. FA.FAUI a -> (Signal a -> FA.FAUI a) -> Eff (datgui :: D.DATGUI | e) (Signal a)
bindNew i o = do
  datgui <- D.mkDatGui
  sig <- build i datgui
  sig2 <- build (o sig) datgui
  pure sig2

ignore :: forall a e. a -> Eff e Unit
ignore v = pure unit

runEffSignal :: forall a e1. Eff e1 (Signal a) ->  Eff e1 Unit
runEffSignal effsig = effsig >>= (runSignal <<< map ignore)

bindNewRun :: forall a e. FA.FAUI a -> (Signal a -> FA.FAUI a) -> Eff (datgui :: D.DATGUI | e) Unit
bindNewRun i o = runEffSignal (bindNew i o)
