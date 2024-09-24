module Settings exposing (Settings, decode, encode)

import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Location exposing (Position)


type LocationMethod
    = Ip
    | Gps
    | Manual Position


type Profile
    = TorontoWinter
    | TorontoSummer
    | Milwaukee


type alias Settings =
    { locationMethod : LocationMethod, profile : Profile }


decode value =
    D.decodeValue settingsDecoder value
        |> Result.withDefault { locationMethod = Ip, profile = TorontoWinter }


settingsDecoder : Decoder Settings
settingsDecoder =
    D.map2 Settings
        (D.field "locationMethod" D.string |> D.andThen decodeLocationMethod)
        (D.field "profile" D.string |> D.andThen decodeProfile)


decodeLocationMethod : String -> Decoder LocationMethod
decodeLocationMethod method =
    case method of
        "ip" ->
            D.succeed Ip

        "gps" ->
            D.succeed Gps

        "manual" ->
            Location.decodePosition |> D.map Manual

        _ ->
            D.fail "Invalid location method"


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

        manualPosition =
            case settings.locationMethod of
                Manual position ->
                    [ ( "manualPosition", Location.encodePosition position ) ]

                _ ->
                    []
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

        Manual _ ->
            "manual"
