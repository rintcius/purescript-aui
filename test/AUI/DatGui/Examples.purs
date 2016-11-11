module AUI.DatGui.Examples where

import Prelude
import AUI.AUI as A
import AUI.DatGui.DatGui as D
import AUI.DatGui.Interpreter as I
import AUI.FreeApAUI as FA
import Control.Apply (lift2)
import Control.Monad.Eff (Eff)
import Data.List (List(Nil), (:))
import Data.Traversable (traverse, sum)
import Math (pow)
import Signal (foldp, (~>))

ui1 :: FA.FAUI Number
ui1 = pow <$> FA.numberField "Base" 2.0 <*> FA.numberField "Exponent" 10.0

ui2 :: FA.FAUI String
ui2 = FA.stringField "" "Hello" <> pure " " <> FA.stringField "" "World"

ui3 :: FA.FAUI Int
ui3 = sum <$> traverse (FA.intField "") [2, 13, 27, 42]

ui4 :: FA.FAUI Number
ui4 = lift2 (/) (FA.numberField "" 5.0) (FA.numberField "" 2.0)

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

main :: forall e. Eff (datgui :: D.DATGUI | e) Unit
main = do
  I.buildAndRunIO ui1 (FA.outputField "pow")
  I.buildAndRunIO ui2 (FA.outputField "output")
  I.buildAndRunIO ui3 (FA.outputField "output")
  I.buildAndRunIO ui6 (FA.outputField "output")
  I.buildAndRunIO ui9 (FA.outputField "output")
  I.buildAndRunIO ui11 (FA.outputField "output" <<< (foldp (+) 0))
