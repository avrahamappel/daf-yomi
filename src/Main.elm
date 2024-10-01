port module Main exposing (..)

import Array
import Browser
import Data exposing (..)
import Errors
import Format exposing (posixToTimeString)
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as D
import Json.Encode
import Location exposing (Position)
import Settings exposing (Settings)
import Task
import Time exposing (Posix, Weekday(..), Zone)



-- PORTS


port getData : { settings : Json.Encode.Value, timestamp : Int, position : Position } -> Cmd msg


port returnData : (Json.Encode.Value -> msg) -> Sub msg



-- MAIN


main : Program Json.Encode.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { curTime : Int
    , curShiurIndex : Int
    , curZemanIndex : Int
    , initTime : Int
    , timezone : Zone
    , state : State
    , settings : Settings
    }


type State
    = LoadingData
    | Error String
    | HasPosition Position
    | HasData Data Position


init : Json.Encode.Value -> ( Model, Cmd Msg )
init value =
    ( Model 0 0 0 0 Time.utc LoadingData (Settings.decode value)
    , Task.map2 AdjustTime Time.here Time.now |> Task.perform (\x -> x)
    )



-- UPDATE


type Msg
    = None
    | AdjustTime Zone Posix
    | SetLocation Json.Encode.Value
    | SetData Json.Encode.Value
    | ChangeDate SwitcherMsg
    | ChangeZeman SwitcherMsg
    | ChangeShiur SwitcherMsg
    | ReceiveError String


dayInMillis : Int
dayInMillis =
    1000 * 60 * 60 * 24


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        AdjustTime tz pos ->
            let
                curTime =
                    Time.posixToMillis pos
            in
            ( { model | initTime = curTime, curTime = curTime, timezone = tz }
            , Cmd.none
            )

        SetLocation json ->
            let
                position =
                    D.decodeValue Location.decodePosition json
            in
            case position of
                Err e ->
                    ( { model | state = Error (D.errorToString e) }, Cmd.none )

                Ok pos ->
                    ( { model | state = HasPosition pos }
                    , getData
                        { timestamp = model.curTime
                        , position = pos
                        , settings = Settings.encode model.settings
                        }
                    )

        SetData json ->
            let
                state =
                    case model.state of
                        HasPosition pos ->
                            case D.decodeValue dataDecoder json of
                                Ok data ->
                                    HasData data pos

                                Err e ->
                                    Error (D.errorToString e)

                        _ ->
                            model.state

                nextZemanIndex curTime =
                    case state of
                        HasData data _ ->
                            case data.zemanimState of
                                HasZemanim zmnm ->
                                    zmnm.zemanim
                                        |> Array.indexedMap Tuple.pair
                                        |> Array.filter
                                            (\( _, zn ) ->
                                                Time.posixToMillis zn.value >= curTime
                                            )
                                        |> Array.map Tuple.first
                                        |> Array.toList
                                        |> List.head
                                        |> Maybe.withDefault 0

                                _ ->
                                    0

                        _ ->
                            0
            in
            ( { model
                | state = state
                , -- If currently showing today, set the zeman index to the next zeman for today
                  curZemanIndex =
                    if model.curTime == model.initTime then
                        nextZemanIndex model.curTime

                    else
                        model.curZemanIndex
              }
            , Cmd.none
            )

        ChangeDate switchMsg ->
            let
                newTime =
                    case switchMsg of
                        Right ->
                            model.curTime + dayInMillis

                        Left ->
                            model.curTime - dayInMillis

                        Middle ->
                            -- Reset to initial
                            model.initTime
            in
            case model.state of
                HasData _ pos ->
                    ( { model | curTime = newTime, state = HasPosition pos }
                    , getData { timestamp = newTime, position = pos, settings = Settings.encode model.settings }
                    )

                _ ->
                    ( model, Cmd.none )

        ChangeZeman switchMsg ->
            let
                newIndex curIndex zmnm =
                    case switchMsg of
                        Left ->
                            (if curIndex == 0 then
                                Array.length zmnm.zemanim

                             else
                                curIndex
                            )
                                - 1

                        Right ->
                            let
                                index =
                                    curIndex + 1
                            in
                            if index == Array.length zmnm.zemanim then
                                0

                            else
                                index

                        Middle ->
                            curIndex

                newZemanimIndex =
                    case model.state of
                        HasData data _ ->
                            case data.zemanimState of
                                HasZemanim zmnm ->
                                    newIndex model.curZemanIndex zmnm

                                _ ->
                                    model.curZemanIndex

                        _ ->
                            model.curZemanIndex
            in
            ( { model | curZemanIndex = newZemanimIndex }, Cmd.none )

        ChangeShiur switchMsg ->
            let
                newIndex curIndex shiurim =
                    case switchMsg of
                        Left ->
                            (if curIndex == 0 then
                                Array.length shiurim

                             else
                                curIndex
                            )
                                - 1

                        Right ->
                            let
                                index =
                                    curIndex + 1
                            in
                            if index == Array.length shiurim then
                                0

                            else
                                index

                        Middle ->
                            curIndex

                -- TODO show text
                newShiurIndex =
                    case model.state of
                        HasData data _ ->
                            newIndex model.curShiurIndex data.shiurim

                        _ ->
                            model.curShiurIndex
            in
            ( { model | curShiurIndex = newShiurIndex }, Cmd.none )

        ReceiveError error ->
            ( { model | state = Error error }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Location.setLocation SetLocation
        , returnData SetData
        , Errors.receiveError ReceiveError
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        vs =
            case model.state of
                LoadingData ->
                    [ text "Fetching position..." ]

                Error e ->
                    [ span [ style "color" "red" ] [ text e ] ]

                HasPosition _ ->
                    [ text "Loading data..." ]

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
                                            "יום ו׳"

                                        Sat ->
                                            "ש״ק"
                            in
                            case data.parsha of
                                Nothing ->
                                    weekday

                                Just parsha ->
                                    weekday ++ " " ++ parsha
                    in
                    [ switcher data.hdate (weekAndDay model.timezone model.curTime) ChangeDate
                    , div [ class "sub-text" ] [ text data.date ]
                    , switcher shiurimLine1 shiurimLine2 ChangeShiur
                    , br [] []
                    , switcher zemanimLine1 zemanimLine2 ChangeZeman
                    , div [ class "sub-text" ] [ text location ]
                    ]
    in
    div [ id "app" ] vs


{-| An HTML group consisting of a middle field with a right and left pointing
arrow to increment and decrement the value
-}
switcher : String -> String -> (SwitcherMsg -> msg) -> Html msg
switcher line1 line2 msg =
    div [ class "switcher-group" ]
        [ button [ class "switcher-left", onClick (msg Left) ] [ text "<" ]
        , button [ class "switcher-middle", onClick (msg Middle) ]
            [ text line1
            , br [] []
            , text line2
            ]
        , button [ class "switcher-right", onClick (msg Right) ] [ text ">" ]
        ]


type SwitcherMsg
    = Right
    | Left
    | Middle
