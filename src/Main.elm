port module Main exposing (..)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (Html, br, button, div, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Platform.Sub as Sub
import Task
import Time



-- type alias Shiur =
--     { name :String
--     , value : String
--     }


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
    }


type State
    = LoadingData
    | HasData Data


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 LoadingData, Task.perform AdjustTimestamp Time.now )



-- UPDATE


type Msg
    = None
    | AdjustTimestamp Time.Posix
    | SetData Data
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
                cur_time =
                    Time.posixToMillis pos
            in
            ( { model | cur_time = cur_time }, getData cur_time )

        SetData data ->
            ( { model
                | state = HasData data
              }
            , Cmd.none
            )

        UpdateDate switchMsg ->
            let
                new_time =
                    case switchMsg of
                        Incr ->
                            model.cur_time + dayInMillis

                        Decr ->
                            model.cur_time - dayInMillis

                        _ ->
                            model.cur_time
            in
            ( { model | cur_time = new_time, state = LoadingData }, getData new_time )



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
                    UpdateDate Decr

                "ArrowRight" ->
                    UpdateDate Incr

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
                    [ switchable data.hdate data.date UpdateDate
                    , br [] []
                    , switchable "Daf:" data.dafYomi (\_ -> None)
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
