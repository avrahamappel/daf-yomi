port module Main exposing (..)

import Array exposing (Array)
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


type alias Zeman =
    { label : String, value : String }


type alias Data =
    { hdate : String
    , dafYomi : String
    , zemanim : List Zeman
    , zemanimError : String
    }



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
    , zemanim : ZemanimState
    }


type State
    = LoadingData
    | HasData Data


type ZemanimState
    = LoadingZemanim
    | GeoError String
    | HasZemanim
        { zemanim : Array Zeman
        , initialShown : Int
        , curShown : Zeman
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 LoadingData LoadingZemanim, Task.perform AdjustTimestamp Time.now )



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
                , zemanim =
                    if data.zemanimError /= "" then
                        GeoError data.zemanimError

                    else
                        let
                            zmnArray =
                                Array.fromList data.zemanim
                        in
                        HasZemanim
                            { zemanim = zmnArray
                            , curShown =
                                Array.get 0 zmnArray
                                    |> Maybe.withDefault { label = "", value = "" }
                            , initialShown = 0
                            }
              }
            , Cmd.none
            )

        DecrDate ->
            let
                new_time =
                    model.cur_time - dayInMillis
            in
            ( { model | cur_time = new_time, state = LoadingData }, getData new_time )

        IncrDate ->
            let
                new_time =
                    model.cur_time + dayInMillis
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
        zemanim =
            switchable
                None
                None
                (case model.zemanim of
                    LoadingZemanim ->
                        [ text "Loading..." ]

                    HasZemanim zm ->
                        [ text zm.curShown.label
                        , br [] []
                        , text zm.curShown.value
                        ]

                    GeoError e ->
                        [ text "Error", br [] [], text e ]
                )

        vs =
            case model.state of
                LoadingData ->
                    [ text "Loading..." ]

                HasData data ->
                    [ switchable
                        DecrDate
                        IncrDate
                        [ text data.hdate ]
                    , br [] []
                    , switchable
                        None
                        None
                        [ text "Daf:", br [] [], text data.dafYomi ]
                    , br [] []
                    , zemanim
                    ]
    in
    div [ id "app" ] vs


{-| An HTML group consisting of a middle field with a right and left pointing
arrow to increment and decrement the value
-}
switchable : msg -> msg -> List (Html msg) -> Html msg
switchable decrMsg incrMsg vs =
    div [ class "switchable-group" ]
        [ button [ class "switchable-decr", onClick decrMsg ] [ text "<" ]
        , div [ class "switchable-content" ] vs
        , button [ class "switchable-incr", onClick incrMsg ] [ text ">" ]
        ]
