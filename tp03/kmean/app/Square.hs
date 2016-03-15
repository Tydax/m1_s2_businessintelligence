module Main where

import DataLoader

main :: IO ()
main =
  do
    result <- readData "data/square1.data"
    case result of
      Left err -> putStrLn . show $ err
      Right res -> putStrLn . show $ res
      
