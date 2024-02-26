port module Main exposing (..)

import Browser
import Browser.Events exposing (onKeyDown)
import Dict exposing (Dict)
import Html exposing (Html, br, button, div, p, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Platform.Sub as Sub
import Task
import Time


type alias Data =
    { timestamp : Int, date : String, hdate : String, dafYomi : String }



-- PORTS


port getData : Int -> Cmd msg


port returnData : (Data -> msg) -> Sub msg



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
    , cache : Dict Int Data
    }


type State
    = LoadingData
    | HasData Data


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 LoadingData Dict.empty, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetData Data
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
            ( { model | cur_time = cur_time }, getData cur_time )

        SetData data ->
            ( { model
                | state = HasData data
                , cache = Dict.insert data.timestamp data model.cache
              }
            , Cmd.none
            )

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


fetchFromCache : Int -> Dict Int Data -> ( State, Cmd Msg )
fetchFromCache time cache =
    case Dict.get time cache of
        Nothing ->
            ( LoadingData, getData time )

        Just data ->
            ( HasData data, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ returnData SetData
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
    let
        vs =
            case model.state of
                LoadingData ->
                    [ text "Loading..." ]

                HasData data ->
                    [ switchable DecrDate
                        IncrDate
                        [ text data.hdate
                        , br [] []
                        , text data.date
                        ]
                    , p [] [ text "Daf:", br [] [], text data.dafYomi ]
                    ]
    in
    div [ id "app" ] vs


{-| An HTML group consisting of a middle field with a right and left pointing
arrow to increment and decrement the value
-}
switchable : msg -> msg -> List (Html msg) -> Html msg
switchable decrMsg incrMsg vs =
    div [ class "switchable-group" ]
        [ button [ class "switchable-decr", onClick decrMsg ] [ text "⏴" ]
        , div [ class "switchable-content" ] vs
        , button [ class "switchable-incr", onClick incrMsg ] [ text "⏵" ]
        ]
