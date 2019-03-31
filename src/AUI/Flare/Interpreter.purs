module AUI.Flare.Interpreter where

import Prelude

import AUI.AUI as A
import AUI.FreeApAUI as FA
import Control.Applicative.Free (foldFreeAp)
import Data.Iso (forwards, backwards)
import Data.NonEmpty ((:|))
import Effect.Exception.Unsafe (unsafeThrow)
import Flare as F

toUI :: A.AUI ~> F.UI
toUI (A.NumberField l (A.NumberFieldState { value : v, constraints : cs }) f) =
  f <$> nrF cs where
    nrF A.NoNumberConstraints = F.number l v
    nrF (A.WithNumberConstraints c) = F.numberRange l c.min c.max c.step v
toUI (A.IntField l (A.IntFieldState { value : v, constraints : cs }) f) =
  f <$> intF cs where
    intF (A.WithIntConstraints c) = F.intRange l c.min c.max v
    intF A.NoIntConstraints = F.int l v
toUI (A.StringField l v f) = f <$> F.string l v
toUI (A.Checkbox l (A.CheckboxState v@{ status : s })) = toA <$> F.boolean l (toBoolean s) where
  toBoolean = forwards A.isoCheckboxStatusBoolean
  toStatus = backwards A.isoCheckboxStatusBoolean
  toA b = A.selectedCheckbox (A.CheckboxState (v { status = toStatus b }))
toUI (A.Button l (A.ButtonState v)) = F.button l v.up v.down
toUI (A.Selectbox l (A.Select s r toString)) = F.select l (s :| r) toString
toUI (A.RadioGroup l (A.Radio s r toString)) = F.radioGroup l (s :| r) toString
toUI _ = unsafeThrow "TODO"

run :: forall a. FA.FAUI a -> F.UI a
run (FA.FAUI c) = foldFreeAp toUI c
