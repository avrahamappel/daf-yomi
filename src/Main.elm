port module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Json.Encode
import Task
import Time



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
    , initTime : Int
    , state : State
    }


type State
    = LoadingData
    | Error String
    | HasData Data


type alias Data =
    { date : String, hdate : String, shiurim : Shiurim }


type alias Shiurim =
    { shiurim : Array Shiur
    , initialShown : Int
    , curShown : Int
    }


type alias Shiur =
    { name : String, value : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 LoadingData, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetData Json.Encode.Value
    | UpdateDate SwitchMsg
    | ChangeShiur SwitchMsg


dayInMillis : Int
dayInMillis =
    1000 * 60 * 60 * 24


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        AdjustTimestamp pos ->
            let
                curTime =
                    Time.posixToMillis pos
            in
            ( { model | initTime = curTime, curTime = curTime }, getData curTime )

        SetData json ->
            let
                decoder =
                    Decode.map3 Data
                        (Decode.field "date" Decode.string)
                        (Decode.field "hdate" Decode.string)
                        (Decode.field "shiurim"
                            (Decode.map (\arr -> Shiurim arr 0 0)
                                (Decode.array
                                    (Decode.map2 Shiur
                                        (Decode.field "name" Decode.string)
                                        (Decode.field "value" Decode.string)
                                    )
                                )
                            )
                        )

                state =
                    case Decode.decodeValue decoder json of
                        Ok data ->
                            HasData data

                        Err e ->
                            Error (Decode.errorToString e)
            in
            ( { model | state = state }, Cmd.none )

        UpdateDate switchMsg ->
            let
                newTime =
                    case switchMsg of
                        Incr ->
                            model.curTime + dayInMillis

                        Decr ->
                            model.curTime - dayInMillis

                        Click ->
                            -- Reset to initial
                            model.initTime
            in
            ( { model | curTime = newTime, state = LoadingData }, getData newTime )

        ChangeShiur switchMsg ->
            let
                newIndex shiurim =
                    case switchMsg of
                        Decr ->
                            (if shiurim.curShown == 0 then
                                Array.length shiurim.shiurim

                             else
                                shiurim.curShown
                            )
                                - 1

                        Incr ->
                            let
                                index =
                                    shiurim.curShown + 1
                            in
                            if index == Array.length shiurim.shiurim then
                                0

                            else
                                index

                        Click ->
                            shiurim.initialShown

                newShiurim shiurim =
                    { shiurim | curShown = newIndex shiurim }

                newState =
                    case model.state of
                        HasData data ->
                            HasData { data | shiurim = newShiurim data.shiurim }

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
                        ( shiurimLine1, shiurimLine2 ) =
                            case Array.get data.shiurim.curShown data.shiurim.shiurim of
                                Just shiur ->
                                    ( shiur.name, shiur.value )

                                Nothing ->
                                    ( "Error", "No entry for index " ++ String.fromInt data.shiurim.curShown )
                    in
                    [ switchable data.hdate data.date UpdateDate
                    , br [] []
                    , switchable shiurimLine1 shiurimLine2 ChangeShiur
                    , br [] []
                    , switchable "זמנים" "Coming soon..." (\_ -> None)
                    ]
    in
    div [ id "app" ] vs


{-| An HTML group consisting of a middle field with a right and left pointing
arrow to increment and decrement the value
-}
switchable : String -> String -> (SwitchMsg -> msg) -> Html msg
switchable line1 line2 msg =
    div [ class "switchable-group" ]
        [ button [ class "switchable-decr", onClick (msg Decr) ] [ text "<" ]
        , button [ class "switchable-content", onClick (msg Click) ]
            [ text line1
            , br [] []
            , text line2
            ]
        , button [ class "switchable-incr", onClick (msg Incr) ] [ text ">" ]
        ]


type SwitchMsg
    = Incr
    | Decr
    | Click
