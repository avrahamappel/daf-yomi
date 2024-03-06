port module Main exposing (..)

import Array exposing (Array)
import Browser
import Html exposing (Html, br, button, div, span, text)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Json.Decode as D exposing (Decoder)
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
    { date : String
    , hdate : String
    , dafYomi : String
    , zemanimState : ZemanimState
    }


dataDecoder : Decoder Data
dataDecoder =
    D.map4 Data
        (D.field "date" D.string)
        (D.field "hdate" D.string)
        (D.field "dafYomi" D.string)
        zemanimStateDecoder


type ZemanimState
    = GeoError String
    | HasZemanim Zemanim


zemanimStateDecoder : Decoder ZemanimState
zemanimStateDecoder =
    D.oneOf
        [ D.map GeoError (D.field "zemanimError" D.string)
        , D.map HasZemanim zemanimDecoder
        ]


type alias Zemanim =
    { zemanim : Array Zeman
    , initialShown : Int
    , curShown : Int
    , latitude : String
    , longitude : String
    }


zemanimDecoder : Decoder Zemanim
zemanimDecoder =
    D.map3 zemanim
        (D.field "latitude" D.string)
        (D.field "longitude" D.string)
        (D.field "zemanim" (D.array zemanDecoder))


zemanim : String -> String -> Array Zeman -> Zemanim
zemanim lat long zmnm =
    -- TODO set index based on cur time
    -- let
    --     nextZemanIndex = zemanim
    -- in
    Zemanim zmnm 0 0 lat long


type alias Zeman =
    { name : String, value : String }


zemanDecoder : Decoder Zeman
zemanDecoder =
    D.map2 Zeman
        (D.field "name" D.string)
        (D.field "value" D.string)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 LoadingData, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetData Json.Encode.Value
    | UpdateDate SwitchMsg


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
                state =
                    case D.decodeValue dataDecoder json of
                        Ok data ->
                            HasData data

                        Err e ->
                            Error (D.errorToString e)
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
                                            ( zm.name, zm.value )

                                        Nothing ->
                                            ( "Error", "No entry for index " ++ String.fromInt zmnm.curShown )

                                GeoError e ->
                                    ( "Error", e )
                    in
                    [ switchable data.hdate data.date UpdateDate
                    , br [] []
                    , switchable "דף היומי" data.dafYomi (\_ -> None)
                    , br [] []
                    , switchable zemanimLine1 zemanimLine2 (\_ -> None)
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
