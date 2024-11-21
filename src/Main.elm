port module Main exposing (..)

import Array
import Browser
import Data exposing (..)
import DateFormat
import Format exposing (posixToTimeString)
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as D
import Json.Encode
import Location exposing (Position)
import Settings exposing (Settings, update, view)
import Task
import Time exposing (Posix, Weekday(..), Zone)



-- PORTS


port getData : { settings : Json.Encode.Value, timestamp : Int, position : Position } -> Cmd msg


port returnData : (Json.Encode.Value -> msg) -> Sub msg


port storeSettings : Json.Encode.Value -> Cmd msg


port receiveError : (String -> msg) -> Sub msg



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
    , dispTime : Int
    , timezone : Zone
    , page : Page
    , state : State
    , settings : Settings
    }


type Page
    = Main
    | Settings


type State
    = LoadingData
    | Error String
    | HasPosition Position
    | HasData Data Position


init : Json.Encode.Value -> ( Model, Cmd Msg )
init settings =
    ( { curTime = 0
      , curShiurIndex = 0
      , curZemanIndex = 0
      , dispTime = 0
      , timezone = Time.utc
      , page = Main
      , state = LoadingData
      , settings = Settings.decode settings
      }
    , getCurrentZoneAndTime
    )


getCurrentZoneAndTime : Cmd Msg
getCurrentZoneAndTime =
    Task.map2 AdjustTime Time.here Time.now
        |> Task.perform (\x -> x)



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
    | OpenSettings
    | CloseSettings
    | UpdateSettings Settings.Msg
    | SaveSettings
    | UpdateTime Posix


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
                newTime =
                    Time.posixToMillis pos

                newTimeIsWithin3DaysOfDispTime =
                    abs (newTime - model.dispTime) <= (3 * 24 * 60 * 60 * 1000)

                dispTime =
                    if model.dispTime == 0 then
                        -- dispTime has never been set
                        newTime

                    else if newTimeIsWithin3DaysOfDispTime then
                        -- if the date we are viewing is less than three days
                        -- away from the current date, use new time
                        -- for dispTime as well
                        newTime

                    else
                        model.dispTime

                isViewingCurrentZeman =
                    upcomingZemanIndex model.state model.dispTime
                        == model.curZemanIndex

                newZemanimIndex =
                    upcomingZemanIndex model.state newTime

                zemanIndex =
                    if
                        newTimeIsWithin3DaysOfDispTime
                            && isViewingCurrentZeman
                    then
                        newZemanimIndex

                    else
                        model.curZemanIndex
            in
            ( { model
                | dispTime = dispTime
                , curTime = newTime
                , timezone = tz
                , curZemanIndex = zemanIndex
              }
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
                        { timestamp = model.dispTime
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

                asDate =
                    DateFormat.format
                        [ DateFormat.yearNumber
                        , DateFormat.dayOfYearNumber
                        ]
                        model.timezone
                        << Time.millisToPosix

                isDisplayingCurrentDate =
                    asDate model.curTime == asDate model.dispTime
            in
            ( { model
                | state = state
                , -- If currently showing today, set the zeman index to the next zeman for today
                  curZemanIndex =
                    if isDisplayingCurrentDate then
                        upcomingZemanIndex state model.curTime

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
                            model.dispTime + dayInMillis

                        Left ->
                            model.dispTime - dayInMillis

                        Middle ->
                            -- Reset to initial
                            model.curTime
            in
            case model.state of
                HasData _ pos ->
                    ( { model | dispTime = newTime, state = HasPosition pos }
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
                            upcomingZemanIndex model.state model.curTime

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

        OpenSettings ->
            ( { model | page = Settings }, Cmd.none )

        CloseSettings ->
            ( { model | page = Main }, Cmd.none )

        UpdateSettings m ->
            ( { model
                | settings =
                    Settings.update m model.settings
              }
            , Cmd.none
            )

        SaveSettings ->
            let
                settingsJson =
                    Settings.encode model.settings

                cmd =
                    Cmd.batch
                        [ Location.getLocation settingsJson
                        , storeSettings settingsJson
                        ]
            in
            ( { model | page = Main }, cmd )

        UpdateTime _ ->
            ( model, getCurrentZoneAndTime )


{-| Figure out what the next upcoming zeman for the current time is
-}
upcomingZemanIndex : State -> Int -> Int
upcomingZemanIndex state curTime =
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Location.setLocation SetLocation
        , returnData SetData
        , receiveError ReceiveError
        , -- Update the time every minute
          -- More often would be too jarring for the displayed zeman to suddenly flip
          Time.every (1000 * 60) UpdateTime
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        mainView =
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

        vs =
            case model.page of
                Main ->
                    mainView
                        ++ [ br [] []
                           , br [] []
                           , br [] []
                           , button [ class "ctl-button", onClick OpenSettings ] [ text "Settings" ]
                           ]

                Settings ->
                    [ Html.map UpdateSettings (Settings.view model.settings)
                    , br [] []
                    , button [ class "ctl-button", onClick SaveSettings ] [ text "Save" ]
                    , button [ class "ctl-button", onClick CloseSettings ] [ text "Close" ]
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
