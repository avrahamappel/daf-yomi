module Settings exposing (Settings, decode, encode)

import Json.Decode as D exposing (Decoder)
import Json.Encode as E


type LocationMethod
    = Ip
    | Gps
    | Manual


type Profile
    = TorontoWinter
    | TorontoSummer
    | Milwaukee


type alias Settings =
    { locationMethod : LocationMethod, profile : Profile, longitude : Maybe Float, latitude : Maybe Float }


decode : D.Value -> Settings
decode value =
    D.decodeValue settingsDecoder value
        |> Result.withDefault { locationMethod = Ip, profile = TorontoWinter, longitude = Nothing, latitude = Nothing }


settingsDecoder : Decoder Settings
settingsDecoder =
    D.map4 Settings
        (D.field "locationMethod" D.string |> D.andThen decodeLocationMethod)
        (D.field "profile" D.string |> D.andThen decodeProfile)
        (D.maybe (D.field "longitude" D.float))
        (D.maybe (D.field "latitude" D.float))


decodeLocationMethod : String -> Decoder LocationMethod
decodeLocationMethod method =
    case method of
        "ip" ->
            D.succeed Ip

        "gps" ->
            D.succeed Gps

        "manual" ->
            D.succeed Manual

        _ ->
            D.fail "Invalid location method"


decodeProfile : String -> Decoder Profile
decodeProfile profile =
    case profile of
        "to-w" ->
            D.succeed TorontoWinter

        "to-s" ->
            D.succeed TorontoSummer

        "mwk" ->
            D.succeed Milwaukee

        _ ->
            D.fail "Invalid profile"


encode : Settings -> E.Value
encode settings =
    let
        profile =
            profileString settings.profile

        locationMethod =
            locationMethodString settings.locationMethod

        manualPositionKeys =
            [ "longitude", "latitude" ]

        manualPosition =
            [ settings.longitude
            , settings.latitude
            ]
                |> List.filterMap (\x -> x)
                |> List.map E.float
                |> List.map2 Tuple.pair manualPositionKeys
    in
    E.object
        ([ ( "profile", E.string profile )
         , ( "locationMethod", E.string locationMethod )
         ]
            ++ manualPosition
        )


profileString : Profile -> String
profileString profile =
    case profile of
        TorontoWinter ->
            "to-w"

        TorontoSummer ->
            "to-s"

        Milwaukee ->
            "mwk"


locationMethodString : LocationMethod -> String
locationMethodString locationMethod =
    case locationMethod of
        Ip ->
            "ip"

        Gps ->
            "gps"

        Manual ->
            "manual"
