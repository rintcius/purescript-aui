module AUI.DatGui.Interpreter where

import Prelude

import AUI.AUI as A
import AUI.DatGui.DUI (DUI(DUI))
import AUI.DatGui.DatGui as D
import AUI.FreeApAUI as FA
import Control.Applicative.Free (foldFreeAp)
import Data.Array (fromFoldable)
import Data.Iso (backwards, forwards)
import Effect (Effect)
import Effect.Exception.Unsafe (unsafeThrow)
import Signal (runSignal, Signal)

toUI :: forall e. A.AUI ~> DUI e
toUI (A.NumberField l (A.NumberFieldState { value : v, constraints : cs }) f) = DUI $ add cs where
  add (A.WithNumberConstraints n) = D.addNumberToGui l (f v) n.min n.max n.step
  add A.NoNumberConstraints = D.addToGui l (f v)
toUI (A.IntField l (A.IntFieldState { value : v, constraints : cs }) f) = DUI $ add cs where
  add (A.WithIntConstraints c) = D.addIntToGui l (f v) c.min c.max
  add A.NoIntConstraints = D.addIntToGui l (f v) bottom top
toUI (A.StringField l v f) = DUI $ D.addToGui l (f v)
toUI (A.Checkbox l (A.CheckboxState v@{ status : s })) = DUI $ mapToA <$> D.addToGui l (toBoolean s) where
  toBoolean = forwards A.isoCheckboxStatusBoolean
  toStatus = backwards A.isoCheckboxStatusBoolean
  toA b = A.selectedCheckbox (A.CheckboxState (v { status = toStatus b }))
  --TODO why does it give an error if this is inlined above?
  --Error here: https://gist.github.com/rintcius/71dea1f9ebe471eeb63395ff3278459f
  mapToA = map (map toA)
toUI (A.Button l (A.ButtonState v)) = DUI $ D.addButtonToGui l v.up v.down
toUI (A.Selectbox l (A.Select s r toString)) = DUI $ D.addSelectToGui l s (fromFoldable r) toString
toUI (A.OutputField l s) = DUI $ D.addOutputToGui l s
toUI _ = unsafeThrow "TODO"

run :: forall a e. FA.FAUI a -> DUI e a
run (FA.FAUI c) = foldFreeAp toUI c

applyGui :: forall a e. D.DatGui -> DUI e a -> Effect (Signal a)
applyGui gui (DUI dg) = dg gui

build :: forall a. FA.FAUI a -> D.DatGui -> Effect (Signal a)
build faui gui = applyGui gui (run faui)

buildNew :: forall a. FA.FAUI a -> Effect (Signal a)
buildNew faui = D.mkDatGui >>= build faui

runNew :: forall a. FA.FAUI a -> (a -> Effect Unit) -> Effect Unit
runNew faui x = buildNew faui >>= (\sig -> runSignal (map x sig))

bindNew :: forall a. FA.FAUI a -> (Signal a -> FA.FAUI a) -> Effect (Signal a)
bindNew i o = do
  datgui <- D.mkDatGui
  sig <- build i datgui
  sig2 <- build (o sig) datgui
  pure sig2

ignore :: forall a. a -> Effect Unit
ignore v = pure unit

runEffSignal :: forall a. Effect (Signal a) ->  Effect Unit
runEffSignal effsig = effsig >>= (runSignal <<< map ignore)

bindNewRun :: forall a. FA.FAUI a -> (Signal a -> FA.FAUI a) -> Effect Unit
bindNewRun i o = runEffSignal (bindNew i o)
