module Settings exposing
    ( Msg
    , Settings
    , decode
    , encode
    , update
    , view
    )

import Html exposing (Html, br, div, h1, input, label, text)
import Html.Attributes exposing (checked, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
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
                -- This is how you do List.zip in Elm
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



-- UPDATE


type Msg
    = UpdateLocationMethod LocationMethod
    | UpdateProfile Profile
    | UpdateLongitude String
    | UpdateLatitude String


update : Msg -> Settings -> Settings
update msg settings =
    case msg of
        UpdateLocationMethod method ->
            { settings | locationMethod = method }

        UpdateProfile profile ->
            { settings | profile = profile }

        UpdateLongitude longitudeStr ->
            { settings | longitude = String.toFloat longitudeStr }

        UpdateLatitude latitudeStr ->
            { settings | latitude = String.toFloat latitudeStr }



-- VIEW


view : Settings -> Html Msg
view settings =
    div [ style "text-align" "left" ]
        [ h1 [] [ text "Settings" ]
        , div []
            [ text "Location Method:"
            , div []
                [ label []
                    [ input [ type_ "radio", checked (settings.locationMethod == Ip), onClick (UpdateLocationMethod Ip) ] []
                    , text " IP"
                    ]
                , br [] []
                , label []
                    [ input [ type_ "radio", checked (settings.locationMethod == Gps), onClick (UpdateLocationMethod Gps) ] []
                    , text " GPS"
                    ]
                , br [] []
                , label []
                    [ input
                        [ type_ "radio", checked (settings.locationMethod == Manual), onClick (UpdateLocationMethod Manual) ]
                        []
                    , text " Manual"
                    ]
                ]
            ]
        , case settings.locationMethod of
            Manual ->
                div []
                    [ label []
                        [ text "Longitude: "
                        , input
                            [ placeholder "75.000"
                            , type_ "number"
                            , value (settings.longitude |> Maybe.map String.fromFloat |> Maybe.withDefault "")
                            , onInput UpdateLongitude
                            ]
                            []
                        ]
                    , br [] []
                    , label []
                        [ text "Latitude: "
                        , input
                            [ placeholder "45.000"
                            , type_ "number"
                            , value (settings.latitude |> Maybe.map String.fromFloat |> Maybe.withDefault "")
                            , onInput UpdateLatitude
                            ]
                            []
                        ]
                    ]

            _ ->
                text ""
        , br [] []
        , div []
            [ text "Profile:"
            , div []
                [ label []
                    [ input [ type_ "radio", checked (settings.profile == TorontoWinter), onClick (UpdateProfile TorontoWinter) ] []
                    , text " Toronto -- Winter"
                    ]
                , br [] []
                , label []
                    [ input [ type_ "radio", checked (settings.profile == TorontoSummer), onClick (UpdateProfile TorontoSummer) ] []
                    , text " Toronto -- Summer"
                    ]
                , br [] []
                , label []
                    [ input [ type_ "radio", checked (settings.profile == Milwaukee), onClick (UpdateProfile Milwaukee) ] []
                    , text " Milwaukee"
                    ]
                ]
            ]
        ]
