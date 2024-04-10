port module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as D exposing (Decoder)
import Json.Encode
import Task
import Time exposing (Posix, Weekday(..), Zone)



-- PORTS


port getData : Int -> Cmd msg


port returnData : (Json.Encode.Value -> msg) -> Sub msg



-- MAIN


main : Program () Model Msg
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
    }


type State
    = LoadingData
    | Error String
    | HasData Data


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


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 0 0 Time.utc LoadingData
    , Task.map2 AdjustTime Time.here Time.now |> Task.perform (\x -> x)
    )



-- UPDATE


type Msg
    = None
    | AdjustTime Zone Posix
    | SetData Json.Encode.Value
    | ChangeDate SwitcherMsg
    | ChangeZeman SwitcherMsg
    | ChangeShiur SwitcherMsg


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
            , getData curTime
            )

        SetData json ->
            let
                state =
                    case D.decodeValue dataDecoder json of
                        Ok data ->
                            HasData data

                        Err e ->
                            Error (D.errorToString e)

                nextZemanIndex curTime =
                    case state of
                        HasData data ->
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
            ( { model | curTime = newTime, state = LoadingData }
            , getData newTime
            )

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
                        HasData data ->
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
                        HasData data ->
                            newIndex model.curShiurIndex data.shiurim

                        _ ->
                            model.curShiurIndex
            in
            ( { model | curShiurIndex = newShiurIndex }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    returnData SetData



-- VIEW


view : Model -> Html Msg
view model =
    let
        vs =
            case model.state of
                LoadingData ->
                    [ text "Loading..." ]

                Error e ->
                    [ span [ style "color" "red" ] [ text e ] ]

                HasData data ->
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
                                            "שבת קודש"
                            in
                            case data.parsha of
                                Nothing ->
                                    weekday

                                Just parsha ->
                                    weekday ++ " " ++ parsha
                    in
                    [ switcher data.hdate (weekAndDay model.timezone model.curTime) ChangeDate
                    , div [ class "sub-text" ] [ text data.date ]
                    , br [] []
                    , switcher shiurimLine1 shiurimLine2 ChangeShiur
                    , br [] []
                    , switcher zemanimLine1 zemanimLine2 ChangeZeman
                    , div [ class "sub-text" ] [ text location ]
                    ]
    in
    div [ id "app" ] vs


{-| Format a posix value to a time string
-}
posixToTimeString : Time.Zone -> Posix -> String
posixToTimeString z p =
    let
        hour =
            Time.toHour z p

        minute =
            (if Time.toMillis z p >= 500 then
                1

             else
                0
            )
                + (if Time.toSecond z p >= 30 then
                    1

                   else
                    0
                  )
                + Time.toMinute z p

        pm =
            hour - 12 >= 0

        formattedTime =
            String.fromInt
                (if pm then
                    hour - 12

                 else if hour == 0 then
                    12

                 else
                    hour
                )
                ++ ":"
                ++ String.padLeft 2 '0' (String.fromInt minute)
                ++ (if pm then
                        " pm"

                    else
                        " am"
                   )
    in
    formattedTime


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
