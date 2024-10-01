port module Errors exposing (..)


port receiveError : (String -> msg) -> Sub msg
