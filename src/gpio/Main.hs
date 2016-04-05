module Main (main) where

import Control.Concurrent

import Spyphone.Prelude
import Spyphone.GPIO

-- TODO:
-- Parse simple input commands and test running against raspberrypi
main :: IO ()
main =
    getArgs >>= \case
        [x] -> case readMay x of
            Nothing -> error "usage: gpio [timeout (s)]"
            Just i  -> run i
        _ -> run 1
  where
    run s = do
        putStrLn "In program"
        pin <- initWrite 18
        putStrLn $ "Got pin: " ++ show pin
        set pin HI
        putStrLn "Set to HI"
        v <- read pin
        putStrLn $ "Pin value: " <> show v
        threadDelay (1000000 * s)
        putStrLn "Delay over"
        set pin LO
        v' <- read pin
        putStrLn $ "Pin value: " <> show v'
        close pin
