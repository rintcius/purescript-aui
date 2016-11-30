module AUI.DatGui.Examples where

import Prelude
import AUI.DatGui.DatGui as D
import AUI.DatGui.Interpreter as I
import AUI.FreeApAUI as FA
import AUI.Examples as Ex
import Control.Monad.Eff (Eff)
import Signal (foldp)

main :: forall e. Eff (datgui :: D.DATGUI | e) Unit
main = do
  I.bindNewRun Ex.ui1  (FA.outputField "pow")
  I.bindNewRun Ex.ui2  (FA.outputField "output")
  I.bindNewRun Ex.ui3  (FA.outputField "sum")
  I.bindNewRun Ex.ui4  (FA.outputField "/")
  I.bindNewRun Ex.ui6  (FA.outputField "greet")
  I.bindNewRun Ex.ui9  (FA.outputField "&&")
  I.bindNewRun Ex.ui11 (FA.outputField "count" <<< (foldp (+) 0))
