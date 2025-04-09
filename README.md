# Haskell JSON Parser

A simple JSON parser written in **Haskell** using the **Parsec** library. This parser supports basic JSON types, including objects, arrays, strings, numbers, booleans, and null values.

## Features

- Parses **JSON Objects** and **JSON Arrays**
- Handles **JSON Strings**, **Numbers**, **Booleans**, and **Null** values
- Supports basic **error handling** for malformed JSON
- Written in **Haskell** using the **Parsec** library for parsing

## Setup

1. Clone this repository:
   
   git clone https://github.com/asilov-komron/Haskell-JSON-Parser.git
   
2. Install "Parsec" and Compile the source file:
   cabal install parsec
   ghc JsonParser.hs

3. Execute the compiled file:

   ./JsonParser