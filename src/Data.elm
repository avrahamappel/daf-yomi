module Data exposing (..)

import Array exposing (Array)
import Json.Decode as D exposing (Decoder)
import Time exposing (Posix)


type alias Data =
    { date : String
    , hdate : String
    , zemanimState : ZemanimState
    , shiurim : Shiurim
    , parsha : Maybe String
    }


dataDecoder : Decoder Data
dataDecoder =
    D.map5 Data
        (D.field "date" D.string)
        (D.field "hdate" D.string)
        (D.field "zemanim" zemanimStateDecoder)
        (D.field "shiurim" shiurimDecoder)
        (D.field "parsha" (D.nullable D.string))


type ZemanimState
    = GeoError String
    | HasZemanim Zemanim


zemanimStateDecoder : Decoder ZemanimState
zemanimStateDecoder =
    D.oneOf
        [ D.map GeoError D.string
        , D.map HasZemanim zemanimDecoder
        ]


type alias Zemanim =
    { zemanim : Array Zeman
    , latitude : String
    , longitude : String
    , locationName : Maybe String
    }


zemanimDecoder : Decoder Zemanim
zemanimDecoder =
    D.map4 zemanim
        (D.field "latitude" D.string)
        (D.field "longitude" D.string)
        (D.field "name" (D.nullable D.string))
        (D.field "zemanim" (D.array zemanDecoder))


zemanim : String -> String -> Maybe String -> Array Zeman -> Zemanim
zemanim lat long name zmnm =
    Zemanim zmnm lat long name


type alias Zeman =
    { name : String, value : Posix }


zemanDecoder : Decoder Zeman
zemanDecoder =
    let
        zeman n v =
            Time.millisToPosix v |> Zeman n
    in
    D.map2 zeman
        (D.field "name" D.string)
        (D.field "value" D.int)


type alias Shiurim =
    Array Shiur


shiurimDecoder : Decoder Shiurim
shiurimDecoder =
    D.array
        (D.map2 Shiur
            (D.field "name" D.string)
            (D.field "value" D.string)
        )


type alias Shiur =
    { name : String, value : String }
