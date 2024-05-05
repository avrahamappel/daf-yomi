port module Location exposing
    ( Position
    , decodePosition
    , setLocation
    )

import Json.Decode as D
import Json.Encode


port setLocation : (Json.Encode.Value -> msg) -> Sub msg


type alias Position =
    { name : Maybe String
    , longitude : Float
    , latitude : Float
    , altitude : Maybe Float
    }


decodePosition =
    D.map4 Position
        (D.maybe (D.field "name" D.string))
        (D.field "longitude" D.float)
        (D.field "latitude" D.float)
        (D.maybe (D.field "altitude" D.float))
