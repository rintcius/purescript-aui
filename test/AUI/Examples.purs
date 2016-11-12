module AUI.Examples where

import Prelude
import AUI.AUI as A
import AUI.FreeApAUI as FA
import Control.Apply (lift2)
import Data.List (List(Nil), (:))
import Data.Traversable (traverse, sum)
import Math (pow)

-- Example 1

ui1 :: FA.FAUI Number
ui1 = pow <$> FA.numberField "Base" (state 2.0) <*> FA.numberField "Exponent" (state 10.0) where
  state i = A.NumberFieldState { current : i, constraints : A.WithNumberConstraints { min : -100.0, max : 100.0, step : 0.5 }}

-- Example 2

ui2 :: FA.FAUI String
ui2 = FA.stringField "" "Hello" <> pure " " <> FA.stringField "" "World"

-- Example 3

ui3 :: FA.FAUI Int
ui3 = sum <$> traverse (\i -> FA.intField (label i) (state i)) [2, 13, 27, 42] where
  min   i = (-1) * i
  max   i = i * i
  label i = "[" <> show (min i) <> ".." <> show (max i) <> "]"
  state i = A.IntFieldState { current : i, constraints : A.WithIntConstraints { min : min i, max : max i }}

-- Example 4

ui4 :: FA.FAUI Number
ui4 = lift2 (/) (FA.numberField "" (state 5.0)) (FA.numberField "" (state 2.0)) where
  state i = A.NumberFieldState { current : i, constraints : A.NoNumberConstraints }

-- Example 6

data Language = English | French | German

toString :: Language -> String
toString English = "english"
toString French  = "french"
toString German  = "german"

greet :: Language -> String
greet English = "Hello"
greet French  = "Salut"
greet German  = "Hallo"

ui6 :: FA.FAUI String
ui6 = (greet <$> (FA.selectbox "Language" (A.Select English  (French : German : Nil) toString)))
      <> pure " " <> FA.stringField "Name" "Pierre" <> pure "!"

-- Example 9

ui9 :: FA.FAUI Boolean
ui9 = lift2 (&&) (check A.Unchecked) (check A.Checked) where
  check c = FA.checkbox "" (A.CheckboxState { status : c, checked : true, unchecked : false })

-- Example 11

ui11 :: FA.FAUI Int
ui11 = FA.button "Increment" (A.ButtonState { up : 0, down : 1 })
