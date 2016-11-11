module AUI.FreeApAUI where

import Prelude
import AUI.AUI as A
import Control.Applicative.Free (FreeAp, liftFreeAp)
import Control.Apply (lift2)
import Data.Monoid (mempty, class Monoid)
import Signal (Signal)

newtype FAUI a = FAUI (FreeAp A.AUI a)

instance functorFAUI :: Functor FAUI where
  map f (FAUI a) = FAUI $ map f a

instance applyFAUI :: Apply FAUI where
  apply (FAUI a1) (FAUI a2) = FAUI $ apply a1 a2

instance applicativeFAUI :: Applicative FAUI where
  pure x = FAUI $ pure x

instance semigroupFAUI :: (Semigroup a) => Semigroup (FAUI a) where
  append = lift2 append

instance monoidFAUI :: (Monoid a) => Monoid (FAUI a) where
  mempty = pure mempty

liftFAUI :: forall a. A.AUI a -> FAUI a
liftFAUI = FAUI <<< liftFreeAp

numberField :: A.Label -> Number -> FAUI Number
numberField l v = liftFAUI $ A.NumberField l v id

intField :: A.Label -> A.IntFieldState -> FAUI Int
intField l v = liftFAUI $ A.IntField l v id

stringField :: A.Label -> String -> FAUI String
stringField l v = liftFAUI $ A.StringField l v id

checkbox :: forall a. A.Label -> A.CheckboxState a -> FAUI a
checkbox l v = liftFAUI $ A.Checkbox l v

button :: forall a. A.Label -> A.ButtonState a -> FAUI a
button l v = liftFAUI $ A.Button l v

selectbox :: forall a. A.Label -> A.SelectboxState a -> FAUI a
selectbox l v = liftFAUI $ A.Selectbox l v

radioGroup :: forall a. A.Label -> A.RadioGroupState a -> FAUI a
radioGroup l v = liftFAUI $ A.RadioGroup l v

outputField :: forall a. A.Label -> Signal a -> FAUI a
outputField l s = liftFAUI $ A.OutputField l s
