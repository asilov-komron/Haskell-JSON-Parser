{-# LANGUAGE FlexibleContexts #-}


import Text.Parsec
import Text.Parsec.String (Parser)
import Control.Monad (void)


data JSONValue
  = JSONObject [(String, JSONValue)]  
  | JSONArray [JSONValue]             
  | JSONString String
  | JSONNumber Double
  | JSONBool Bool
  | JSONNull
  deriving (Show)


spaces' :: Parser ()
spaces' = void $ many $ oneOf " \n\t"


parseString :: Parser JSONValue
parseString = do
  char '"'
  content <- many (noneOf ['"'])  
  char '"'
  return $ JSONString content


parseNumber :: Parser JSONValue
parseNumber = do
  num <- many1 (digit <|> char '.')  
  return $ JSONNumber (read num)


parseBool :: Parser JSONValue
parseBool =
      (string "true" >> return (JSONBool True))
  <|> (string "false" >> return (JSONBool False))


parseNull :: Parser JSONValue
parseNull = string "null" >> return JSONNull


parseArray :: Parser JSONValue
parseArray = do
  char '['
  spaces'
  values <- parseValue `sepBy` (spaces' >> char ',' >> spaces')
  spaces'
  char ']'
  return $ JSONArray values


keyValue :: Parser (String, JSONValue)
keyValue = do
  JSONString key <- parseString
  spaces'
  char ':'
  spaces'
  value <- parseValue
  return (key, value)


parseObject :: Parser JSONValue
parseObject = do
  char '{'
  spaces'
  pairs <- keyValue `sepBy` (spaces' >> char ',' >> spaces')
  spaces'
  char '}'
  return $ JSONObject pairs


parseValue :: Parser JSONValue
parseValue = spaces' >> (
      try parseObject
  <|> try parseArray
  <|> try parseString
  <|> try parseNumber
  <|> try parseBool
  <|> parseNull
  )


parseJSON :: String -> Either ParseError JSONValue
parseJSON input = parse (parseValue <* eof) "json" input


main :: IO ()
main = do
  
  let input = "{\"name\": \"Komron\", \"age\": 777, \"isStudent\": true, \"grades\": [5, 4, 3, 5, 5, 4, 5]}"
  case parseJSON input of
    Left err     -> putStrLn $ "Parse error: " ++ show err
    Right result -> print result
