module Spyphone.Prelude
    ( module Spyphone.Prelude
    , module X
    ) where


import ClassyPrelude           as X hiding (show)
import Data.String.Conversions as X (ConvertibleStrings (..))

import qualified Prelude


show' :: Show a => a -> String
show' = Prelude.show

show :: Show a => a -> Text
show = X.tshow
