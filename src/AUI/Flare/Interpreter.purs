module AUI.Flare.Interpreter where

import Prelude
import AUI.AUI as A
import AUI.FreeApAUI as FA
import Flare as F
import Control.Applicative.Free (foldFreeAp)
import Control.Monad.Eff.Exception.Unsafe (unsafeThrow)
import Data.Maybe (fromMaybe)
import Data.NonEmpty ((:|))

toUI :: forall e. A.AUI ~> F.UI e
toUI (A.NumberField l (A.NumberFieldState { current : current, constraints : c }) f) =
  f <$> nr c where
    nr (A.WithNumberConstraints n) = F.numberRange l n.min n.max n.step current
    nr A.NoNumberConstraints = F.number l current
toUI (A.IntField l (A.IntFieldState v) f) =
  f <$> F.intRange l (fromMaybe bottom v.min) (fromMaybe top v.max) v.current
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
