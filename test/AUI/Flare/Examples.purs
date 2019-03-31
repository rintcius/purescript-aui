module AUI.Flare.Examples where

import Prelude

import AUI.Examples as Ex
import AUI.Flare.Interpreter (run)
import Effect (Effect)
import Flare as F

main :: Effect Unit
main = do
  F.runFlareShow     "controls1"   "output1"  (run Ex.ui1)
  F.runFlare         "controls2"   "output2"  (run Ex.ui2)
  F.runFlareShow     "controls3"   "output3"  (run Ex.ui3)
  F.runFlareShow     "controls4"   "output4"  (run Ex.ui4)
  F.runFlareShow     "controls6"   "output6"  (run Ex.ui6)
  F.runFlareShow     "controls9"   "output9"  (run Ex.ui9)
