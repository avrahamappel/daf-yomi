port module Main exposing (..)

import Browser
import Browser.Events exposing (onKeyDown)
import Dict exposing (Dict)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (id)
import Json.Decode as Decode
import Platform.Sub exposing (batch)
import Task
import Time


type alias DafAndDate =
    { date : String, hdate : String, dafYomi : String }



-- PORTS


port getDafAndDate : Int -> Cmd msg


port returnDafAndDate : (DafAndDate -> msg) -> Sub msg



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
    { cur_time : Int
    , state : State
    , cache : Dict Int DafAndDate
    }


type State
    = AwaitingDaf
    | HasDaf DafAndDate


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 AwaitingDaf Dict.empty, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetDafAndDate DafAndDate
    | DecrDate
    | IncrDate


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
                cur_time =
                    Time.posixToMillis pos
            in
            ( { model | cur_time = cur_time }, getDafAndDate cur_time )

        SetDafAndDate dd ->
            ( { model | state = HasDaf dd, cache = Dict.insert model.cur_time dd model.cache }, Cmd.none )

        DecrDate ->
            let
                new_time =
                    model.cur_time - dayInMillis

                ( state, cmd ) =
                    fetchFromCache new_time model.cache
            in
            ( { model | cur_time = new_time, state = state }, cmd )

        IncrDate ->
            let
                new_time =
                    model.cur_time + dayInMillis

                ( state, cmd ) =
                    fetchFromCache new_time model.cache
            in
            ( { model | cur_time = new_time, state = state }, cmd )


fetchFromCache : Int -> Dict Int DafAndDate -> ( State, Cmd Msg )
fetchFromCache time cache =
    case Dict.get time cache of
        Nothing ->
            ( AwaitingDaf, getDafAndDate time )

        Just data ->
            ( HasDaf data, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    batch
        [ returnDafAndDate SetDafAndDate
        , onKeyDown keyDecoder
        ]


keyDecoder : Decode.Decoder Msg
keyDecoder =
    let
        toMsg str =
            case str of
                "ArrowLeft" ->
                    DecrDate

                "ArrowRight" ->
                    IncrDate

                _ ->
                    None
    in
    Decode.map toMsg (Decode.field "key" Decode.string)



-- VIEW


view : Model -> Html Msg
view model =
    case model.state of
        AwaitingDaf ->
            div [ id "app" ] [ text "Loading today's daf..." ]

        HasDaf dd ->
            div [ id "app" ]
                [ p [] [ text dd.date ]
                , p [] [ text dd.hdate ]
                , p [] [ text dd.dafYomi ]
                ]
