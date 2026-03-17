module Viewer exposing (update, view)

import Array
import Data exposing (Data, ZemanimState(..))
import Format exposing (posixToTimeString)
import Html exposing (Html, br, div, span, text)
import Html.Attributes exposing (class, style)
import Switcher exposing (switcher)
import Time exposing (Weekday(..))



-- MODEL


type State
    = LoadingData
    | Error String
    | HasPosition any
    | HasData Data any


type alias Model =
    { state : State }



-- UPDATE


type Msg
    = Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        option1 ->
            Model

        option2 ->
            Model



-- VIEW


view : Model -> Html Msg
view model =
    case model.state of
        LoadingData ->
            text "Fetching position..."

        Error e ->
            span [ style "color" "red" ] [ text e ]

        HasPosition _ ->
            text "Loading data..."

        HasData data _ ->
            let
                ( zemanimLine1, zemanimLine2, location ) =
                    case data.zemanimState of
                        HasZemanim zmnm ->
                            let
                                locationString =
                                    case zmnm.locationName of
                                        Just locationName ->
                                            locationName

                                        Nothing ->
                                            zmnm.latitude ++ ", " ++ zmnm.longitude
                            in
                            case Array.get model.curZemanIndex zmnm.zemanim of
                                Just zm ->
                                    ( zm.name
                                    , posixToTimeString model.timezone zm.value
                                    , locationString
                                    )

                                Nothing ->
                                    ( "Error"
                                    , "No entry for index " ++ String.fromInt model.curZemanIndex
                                    , ""
                                    )

                        GeoError e ->
                            ( "Error", e, "" )

                ( shiurimLine1, shiurimLine2 ) =
                    case Array.get model.curShiurIndex data.shiurim of
                        Just shiur ->
                            ( shiur.name, shiur.value )

                        Nothing ->
                            ( "Error", "No entry for index " ++ String.fromInt model.curShiurIndex )

                weekAndDay zone time =
                    let
                        weekday =
                            case Time.toWeekday zone (Time.millisToPosix time) of
                                Sun ->
                                    "יום א׳"

                                Mon ->
                                    "יום ב׳"

                                Tue ->
                                    "יום ג׳"

                                Wed ->
                                    "יום ד׳"

                                Thu ->
                                    "יום ה׳"

                                Fri ->
                                    "ע״ש"

                                Sat ->
                                    "ש״ק"
                    in
                    weekday ++ " " ++ data.parsha
            in
            [ switcher data.hdate (weekAndDay model.timezone model.dispTime) ChangeDate
            , div [ class "sub-text" ] [ text data.date ]
            , switcher shiurimLine1 shiurimLine2 ChangeShiur
            , br [] []
            , switcher zemanimLine1 zemanimLine2 ChangeZeman
            , div [ class "sub-text" ] [ text location ]
            ]
