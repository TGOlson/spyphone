module Spyphone
    ( main
    ) where

import Spyphone.Prelude
import System.IO (hSetBuffering, BufferMode(..))
import System.Info
import Control.Concurrent

main :: IO ()
main = do
    hSetBuffering stdout LineBuffering
    putStrLn "New build111122222233333444444444"
    print os
    print arch
    putStrLn "??!?bleepYO!!!??"
    loop 0

loop :: Int -> IO ()
loop 10 = putStrLn "Done looping!"
loop i = putStrLn ("Arm-style Loop: " ++ show i) >> threadDelay 100000 >> loop (i + 1)
