module Settings exposing
    ( Msg
    , Settings
    , decode
    , encode
    , update
    , view
    )

import Html exposing (Html, br, div, h1, input, label, option, select, text)
import Html.Attributes exposing (checked, placeholder, selected, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E


type LocationMethod
    = Ip
    | Gps
    | Manual


type alias Settings =
    { locationMethod : LocationMethod
    , longitude : Maybe Float
    , latitude : Maybe Float
    , candleLightingMinutes : Int
    , showPlag : Bool
    }


decode : D.Value -> Settings
decode value =
    D.decodeValue settingsDecoder value
        |> Result.withDefault
            { locationMethod = Ip
            , longitude = Nothing
            , latitude = Nothing
            , candleLightingMinutes = 15
            , showPlag = False
            }


settingsDecoder : Decoder Settings
settingsDecoder =
    D.map5 Settings
        (D.field "locationMethod" D.string |> D.andThen decodeLocationMethod)
        (D.maybe (D.field "longitude" D.float))
        (D.maybe (D.field "latitude" D.float))
        (D.field "candleLightingMinutes" D.int)
        (D.field "showPlag" D.bool)


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


encode : Settings -> E.Value
encode settings =
    let
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
        ([ ( "locationMethod", E.string locationMethod )
         , ( "candleLightingMinutes", E.int settings.candleLightingMinutes )
         , ( "showPlag", E.bool settings.showPlag )
         ]
            ++ manualPosition
        )


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
    | UpdateLongitude String
    | UpdateLatitude String
    | UpdateCandleLightingMinutes String
    | UpdateShowPlag Bool


update : Msg -> Settings -> Settings
update msg settings =
    case msg of
        UpdateLocationMethod method ->
            { settings | locationMethod = method }

        UpdateLongitude longitudeStr ->
            { settings | longitude = String.toFloat longitudeStr }

        UpdateLatitude latitudeStr ->
            { settings | latitude = String.toFloat latitudeStr }

        UpdateCandleLightingMinutes candleLightingStr ->
            { settings | candleLightingMinutes = String.toInt candleLightingStr |> Maybe.withDefault 0 }

        UpdateShowPlag showPlag ->
            { settings | showPlag = showPlag }



-- VIEW


view : Settings -> Html Msg
view settings =
    let
        candleLightingMinutesStr val =
            String.fromInt settings.candleLightingMinutes == val

        candleLightingOptionMapper val =
            option
                [ value val, selected (candleLightingMinutesStr val) ]
                [ text val ]

        candleLightingOptions =
            [ "18", "15", "40" ]
                |> List.map candleLightingOptionMapper
    in
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
                let
                    maybeValue =
                        Maybe.map (String.fromFloat >> value >> List.singleton)
                            >> Maybe.withDefault []
                in
                div []
                    [ label []
                        [ text "Longitude: "
                        , input
                            ([ placeholder "75.000"
                             , type_ "number"
                             , onInput UpdateLongitude
                             ]
                                ++ maybeValue settings.longitude
                            )
                            []
                        ]
                    , br [] []
                    , label []
                        [ text "Latitude: "
                        , input
                            ([ placeholder "45.000"
                             , type_ "number"
                             , onInput UpdateLatitude
                             ]
                                ++ maybeValue settings.latitude
                            )
                            []
                        ]
                    ]

            _ ->
                text ""
        , br [] []
        , div []
            [ div []
                [ label [] [ text "Candlelighting time (minutes before sunset):" ]
                , select [ onInput UpdateCandleLightingMinutes ] candleLightingOptions
                ]
            , div []
                [ label []
                    [ input [ type_ "checkbox", checked settings.showPlag, onCheck UpdateShowPlag ] []
                    , text "Show Plag Hamincha?"
                    ]
                ]
            ]
        ]
