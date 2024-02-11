port module Main exposing (..)

import Browser
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (id)
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


type Model
    = AwaitingDaf
    | HasDaf DafAndDate


init : () -> ( Model, Cmd Msg )
init _ =
    ( AwaitingDaf, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetDafAndDate DafAndDate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        AdjustTimestamp pos ->
            ( AwaitingDaf, getDafAndDate (Time.posixToMillis pos) )

        SetDafAndDate dd ->
            ( HasDaf dd, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    returnDafAndDate SetDafAndDate



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        AwaitingDaf ->
            div [ id "app" ] [ text "Loading today's daf..." ]

        HasDaf dd ->
            div [ id "app" ]
                [ p [] [ text dd.date ]
                , p [] [ text dd.hdate ]
                , p [] [ text dd.dafYomi ]
                ]
