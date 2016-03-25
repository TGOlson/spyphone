module Main where

import System.IO
import Control.Concurrent

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  loop 0

loop :: Int -> IO ()
loop 10 = putStrLn "Done looping!"
loop i = putStrLn ("Loop: " ++ show i) >> threadDelay 100000 >> loop (i + 1)
