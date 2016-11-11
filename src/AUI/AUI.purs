module AUI.AUI where

import Data.List (List, (:))
import Signal (Signal)

type Label = String
data CheckboxStatus = Checked | Unchecked
newtype CheckboxState a = CheckboxState { status :: CheckboxStatus, checked :: a, unchecked :: a }
newtype ButtonState a = ButtonState { up :: a, down :: a }
data SelectboxState a = Select a (List a) (a -> String)
data RadioGroupState a = Radio a (List a) (a -> String)

data AUI a
  = NumberField Label Number (Number -> a)
  | IntField Label Int (Int -> a)
  | StringField Label String (String -> a)
  | Checkbox Label (CheckboxState a)
  | Button Label (ButtonState a)
  | Selectbox Label (SelectboxState a)
  | RadioGroup Label (RadioGroupState a)
  | OutputField Label (Signal a)

selectedCheckbox :: forall a. CheckboxState a -> a
selectedCheckbox (CheckboxState { status : Checked, checked : c }) = c
selectedCheckbox (CheckboxState { status : Unchecked, unchecked : c }) = c

selected :: forall a. SelectboxState a -> a
selected (Select s _ _) = s

selectedRadio :: forall a. RadioGroupState a -> a
selectedRadio (Radio s _ _) = s
