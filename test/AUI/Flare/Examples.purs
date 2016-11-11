module AUI.Flare.Examples where

import Prelude
import AUI.AUI as A
import AUI.FreeApAUI as FA
import Flare as F
import AUI.Flare.Interpreter (run)
import Control.Apply (lift2)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Timer (TIMER)
import DOM (DOM)
import Data.List (List(..), (:))
import Data.Traversable (traverse, sum)
import Graphics.Canvas (CANVAS)
import Math (pow)
import Signal.Channel (CHANNEL)

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

-- Render everything to the DOM

main :: Eff (dom :: DOM, channel :: CHANNEL, canvas :: CANVAS, timer :: TIMER) Unit
main = do
  F.runFlareShow     "controls1"   "output1"  (run ui1)
  F.runFlare         "controls2"   "output2"  (run ui2)
  F.runFlareShow     "controls3"   "output3"  (run ui3)
  F.runFlareShow     "controls4"   "output4"  (run ui4)
  F.runFlareShow     "controls6"   "output6"  (run ui6)
  F.runFlareShow     "controls9"   "output9"  (run ui9)
  F.runFlareShow     "controls11"  "output11" (run ui11)
