module Main exposing (..)

import Browser
import Html exposing (Html, div, p, text)


type Model
    = Model


type Msg
    = None


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd a )
init _ =
    ( Model, Cmd.none )


view : Model -> Html Msg
view _ =
    div []
        [ p [] [ text "January 22, 2024" ]
        , p [] [ text "12 Shevat, 5784" ]
        , p [] [ text "Bava Kamma 81" ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
