port module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as D exposing (Decoder)
import Json.Encode
import Task
import Time exposing (Posix, Zone, ZoneName(..))



-- PORTS


port getData : Json.Encode.Value -> Cmd msg


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
    , initTime : Int
    , location : Location
    , state : State
    }


type alias Location =
    { timezone : Zone
    , zoneName : ZoneName
    }


type State
    = LoadingData
    | Error String
    | HasData Data


type alias Data =
    { date : String
    , hdate : String
    , dafYomi : String
    , zemanimState : ZemanimState
    }


dataDecoder : Int -> Decoder Data
dataDecoder curTime =
    D.map4 Data
        (D.field "date" D.string)
        (D.field "hdate" D.string)
        (D.field "dafYomi" D.string)
        (zemanimStateDecoder curTime)


type ZemanimState
    = GeoError String
    | HasZemanim Zemanim


zemanimStateDecoder : Int -> Decoder ZemanimState
zemanimStateDecoder curTime =
    D.field "zemanim"
        (D.oneOf
            [ D.map GeoError D.string
            , D.map HasZemanim (zemanimDecoder curTime)
            ]
        )


type alias Zemanim =
    { zemanim : Array Zeman
    , initialShown : Int
    , curShown : Int
    , latitude : String
    , longitude : String
    , locationName : Maybe String
    }


zemanimDecoder : Int -> Decoder Zemanim
zemanimDecoder curTime =
    D.map4 (zemanim curTime)
        (D.field "latitude" D.string)
        (D.field "longitude" D.string)
        (D.field "name" (D.nullable D.string))
        (D.field "zemanim" (D.array zemanDecoder))


zemanim : Int -> String -> String -> Maybe String -> Array Zeman -> Zemanim
zemanim curTime lat long name zmnm =
    let
        nextZemanIndex =
            zmnm
                |> Array.indexedMap Tuple.pair
                |> Array.filter
                    (\( _, zn ) ->
                        Time.posixToMillis zn.value >= curTime
                    )
                |> Array.map Tuple.first
                |> Array.toList
                |> List.head
                |> Maybe.withDefault 0
    in
    Zemanim zmnm nextZemanIndex nextZemanIndex lat long name


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


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 (Location Time.utc (Offset 0)) LoadingData
    , Task.map3 AdjustLocationAndTime Time.getZoneName Time.here Time.now
        |> Task.perform (\x -> x)
    )



-- UPDATE


type Msg
    = None
    | AdjustLocationAndTime ZoneName Zone Posix
    | SetData Json.Encode.Value
    | ChangeDate SwitcherMsg
    | ChangeZeman SwitcherMsg


dayInMillis : Int
dayInMillis =
    1000 * 60 * 60 * 24


getDataCmd : ZoneName -> Int -> Cmd Msg
getDataCmd zn ts =
    let
        -- In the case of an offset type, turn something like this:
        -- `-240`
        -- into something like this:
        -- `"-4:00"`
        formatZoneName =
            case zn of
                Name name ->
                    name

                Offset offset ->
                    let
                        absOff =
                            abs offset

                        sign =
                            if offset < 0 then
                                "-"

                            else
                                "+"

                        hrs =
                            absOff // 60 |> String.fromInt

                        mins =
                            modBy absOff 60 |> String.fromInt
                    in
                    sign ++ hrs ++ ":" ++ mins

        json zs =
            Json.Encode.object
                [ ( "timezone", Json.Encode.string zs )
                , ( "timestamp", Json.Encode.int ts )
                ]
    in
    formatZoneName
        |> json
        |> getData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        AdjustLocationAndTime zn tz pos ->
            let
                curTime =
                    Time.posixToMillis pos
            in
            ( { model | initTime = curTime, curTime = curTime, location = Location tz zn }
            , getDataCmd zn curTime
            )

        SetData json ->
            let
                state =
                    case D.decodeValue (dataDecoder model.curTime) json of
                        Ok data ->
                            HasData data

                        Err e ->
                            Error (D.errorToString e)
            in
            ( { model | state = state }, Cmd.none )

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
            , getDataCmd model.location.zoneName newTime
            )

        ChangeZeman switchMsg ->
            let
                newIndex zmnm =
                    case switchMsg of
                        Left ->
                            (if zmnm.curShown == 0 then
                                Array.length zmnm.zemanim

                             else
                                zmnm.curShown
                            )
                                - 1

                        Right ->
                            let
                                index =
                                    zmnm.curShown + 1
                            in
                            if index == Array.length zmnm.zemanim then
                                0

                            else
                                index

                        Middle ->
                            zmnm.initialShown

                newZemanimState state =
                    case state of
                        HasZemanim zmnm ->
                            HasZemanim { zmnm | curShown = newIndex zmnm }

                        _ ->
                            state

                newState =
                    case model.state of
                        HasData data ->
                            HasData { data | zemanimState = newZemanimState data.zemanimState }

                        _ ->
                            model.state
            in
            ( { model | state = newState }, Cmd.none )



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
                        ( zemanimLine1, zemanimLine2 ) =
                            case data.zemanimState of
                                HasZemanim zmnm ->
                                    case Array.get zmnm.curShown zmnm.zemanim of
                                        Just zm ->
                                            ( zm.name, posixToTimeString model.location.timezone zm.value )

                                        Nothing ->
                                            ( "Error", "No entry for index " ++ String.fromInt zmnm.curShown )

                                GeoError e ->
                                    ( "Error", e )
                    in
                    [ switcher data.hdate data.date ChangeDate
                    , br [] []
                    , switcher "דף היומי" data.dafYomi (\_ -> None)
                    , br [] []
                    , switcher zemanimLine1 zemanimLine2 ChangeZeman
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
