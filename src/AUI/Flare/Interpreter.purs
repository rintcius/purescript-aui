module AUI.Flare.Interpreter where

import Prelude
import AUI.AUI as A
import AUI.FreeApAUI as FA
import Flare as F
import Control.Applicative.Free (foldFreeAp)
import Control.Monad.Eff.Exception.Unsafe (unsafeThrow)
import Data.NonEmpty ((:|))

toUI :: forall e. A.AUI ~> F.UI e
toUI (A.NumberField l (A.NumberFieldState { current : current, constraints : cs }) f) =
  f <$> nrF cs where
    nrF A.NoNumberConstraints = F.number l current
    nrF (A.WithNumberConstraints c) = F.numberRange l c.min c.max c.step current
toUI (A.IntField l (A.IntFieldState { current : current, constraints : cs }) f) =
  f <$> intF cs where
    intF (A.WithIntConstraints c) = F.intRange l c.min c.max current
    intF A.NoIntConstraints = F.int l current
toUI (A.StringField l v f) = f <$> F.string l v
toUI (A.Checkbox l (A.CheckboxState v)) = toA <$> F.boolean l (toBoolean v) where
  toBoolean { status : A.Checked } = true
  toBoolean { status : A.Unchecked } = false
  toStatus true = A.Checked
  toStatus false = A.Unchecked
  toA b = A.selectedCheckbox (A.CheckboxState (v { status = toStatus b }))
toUI (A.Button l (A.ButtonState v)) = F.button l v.up v.down
toUI (A.Selectbox l (A.Select s r toString)) = F.select l (s :| r) toString
toUI (A.RadioGroup l (A.Radio s r toString)) = F.radioGroup l (s :| r) toString
toUI _ = unsafeThrow "TODO"

run :: forall a e. FA.FAUI a -> F.UI e a
run (FA.FAUI c) = foldFreeAp toUI c
