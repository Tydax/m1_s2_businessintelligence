{- |
  Module      :  $Header$
  The $Header$ module describes functions used to load data in the application.
-}
module DataLoader (
  createData,
  header,
  file,
  line,
  parseData,
  parseValue,
  readData
) where

import Control.Monad
import Data.Either
import Data.Maybe
import Text.ParserCombinators.Parsec
import Text.Parsec.Char

import Types

header :: Parser ()
header =
  do
    char '@'
    skipMany1 $ noneOf "\r\n"
  <?> "Header"

parseValue :: Parser Double
parseValue =
  do
    number <- many1 (digit <|> char '.' <|> char '-')
    return (read number :: Double)
  <?> "parseValue"

parseData :: Parser Data
parseData =
  do
    vs <- sepBy1 parseValue (char ',')
    return (createData vs)
  <?> "Values"

createData :: [Double] -> Data
createData nbs =
  Data {
    changed = False
  , cluster = -1
  , distanceCentre = -1
  , values = nbs
}

line :: Parser (Maybe Data)
line =
  do
    manyTill (skipMany space) eof
    try
      (header >> return Nothing)
      <|> (parseData >>= return . Just)
      <|> (eof >> return Nothing)

file :: Parser [Data]
file =
  do
    lines <- many1 line
    return $ catMaybes lines

readData :: SourceName -> IO (Either ParseError [Data])
readData name = parseFromFile file name