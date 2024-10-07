port module Location exposing
    ( Position
    , decodePosition
    , encodePosition
    , getLocation
    , setLocation
    )

import Json.Decode as D exposing (Decoder)
import Json.Encode as E exposing (Value)


{-| Trigger a reload of location.
The argument should be a serialized Settings object
-}
port getLocation : Value -> Cmd msg


port setLocation : (Value -> msg) -> Sub msg


type alias Position =
    { name : Maybe String
    , longitude : Float
    , latitude : Float
    , altitude : Maybe Float
    }


decodePosition : Decoder Position
decodePosition =
    D.map4 Position
        (D.maybe (D.field "name" D.string))
        (D.field "longitude" D.float)
        (D.field "latitude" D.float)
        (D.maybe (D.field "altitude" D.float))


encodePosition : Position -> Value
encodePosition pos =
    let
        name =
            case pos.name of
                Just n ->
                    [ ( "name", E.string n ) ]

                Nothing ->
                    []

        altitude =
            case pos.altitude of
                Just a ->
                    [ ( "altitude", E.float a ) ]

                Nothing ->
                    []
    in
    E.object
        ([ ( "longitude", E.float pos.longitude )
         , ( "latitude", E.float pos.latitude )
         ]
            ++ name
            ++ altitude
        )
