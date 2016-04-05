module Spyphone.GPIO
    ( Pin
    , Value(..)
    , Dir(..)
    , initRead
    , initWrite
    , read
    , set
    , close
    ) where

import Spyphone.Prelude

-- Rules:
-- https://www.kernel.org/doc/Documentation/gpio/sysfs.txt
-- https://sites.google.com/site/semilleroadt/raspberry-pi-tutorials/gpio
-- Base path: /sys/class/gpio
-- Writing pin number to /sys/class/gpio/export initializes pin
-- Writing pin number to /sys/class/gpio/unexport closes pin
-- Base pin path /sys/class/gpio<pinNum>
-- Set pin direction /sys/class/gpio<pinNum>/direction (in/out/pwn)
--    also takes HI/LO that set direction to out w/ initial value
-- Note: pwm pulses between hi and lo, probably don't care
-- Set pin value /sys/class/gpio<pinNum>/value (0/1)
-- Edge: 'none', 'rising', 'falling' or 'both'

-- Notes
-- There is edge control that enables polling (really events)
-- Should look into that

-- Core Types ------------------------------------------------------------------

data Pin (a :: Dir) where
    ReadPin  :: Int -> Pin 'In
    WritePin :: Int -> Pin 'Out

deriving instance Show (Pin a)

pinNum :: Pin a -> Int
pinNum = \case ReadPin  i -> i
               WritePin i -> i

pinNumT :: Pin a -> Text
pinNumT = show . pinNum

data Dir = In | Out

instance ToIOData Dir where
    toIOData = \case In  -> "in"
                     Out -> "out"
instance FromIOData Dir where
    fromIOData = \case "in"  -> Right In
                       "out" -> Right Out
                       x     -> Left ("Cannot parse 'Dir' from '" <> x <> "'")

data Value = HI | LO

instance ToIOData Value where
    toIOData = \case HI -> "1"
                     LO -> "0"
instance FromIOData Value where
    fromIOData = \case "1" -> Right HI
                       "0" -> Right LO
                       x   -> Left ("Cannot parse 'Value' from '" <> x <> "'")

-- We are going to do a lot of reading/writing to files w/ custom data types.
-- Create a small interface to keep conversions consistent.
class ToIOData a where
    toIOData :: a -> Text

class FromIOData a where
    fromIOData :: Text -> Either Text a


-- Exported API ----------------------------------------------------------------

initRead :: MonadIO m => Int -> m (Pin 'In)
initRead i = initPin pin >> return pin
  where pin = ReadPin i

initWrite :: Int -> IO (Pin 'Out)
initWrite i = initPin pin >> return pin
  where pin = WritePin i

read :: MonadIO m => Pin a -> m Value
read p =
    fromIOData <$> readFile (valuePath p) >>= \case
        Right v -> return v
        Left e  -> error $ convertString $
            "Error reading value file for " <> show p <> ":" <> e

set :: MonadIO m => Pin 'In -> Value -> m ()
set p v = writeFile (valuePath p) (toIOData v)

close :: MonadIO m => Pin a -> m ()
close p = writeFile unexportPath (pinNumT p)


-- Internal Pin Utils ----------------------------------------------------------

initPin :: MonadIO m => Pin a -> m ()
initPin p = do
    writeFile exportPath (pinNumT p)
    writeFile (directionPath p) (toIOData dir)
  where
    dir :: Dir
    dir = case p of ReadPin _  -> In
                    WritePin _ -> Out


-- Path Utils ------------------------------------------------------------------

basePath :: FilePath
basePath = "/sys/class/gpio"

exportPath :: FilePath
exportPath = basePath <> "/export"

unexportPath :: FilePath
unexportPath = basePath <> "/unexport"

pinPath :: Pin a -> FilePath
pinPath p = basePath <> show' (pinNum p)

valuePath :: Pin a -> FilePath
valuePath p = pinPath p <> "/value"

directionPath :: Pin a -> FilePath
directionPath p = pinPath p <> "/direction"
