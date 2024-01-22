module Main exposing (..)

import Browser


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


init : a -> ( Model, Cmd a )
init _ =
    ( Model, Cmd.none )


view : a
view =
    Debug.todo "TODO"


update : a
update =
    Debug.todo "TODO"


subscriptions : a
subscriptions =
    Debug.todo "TODO"
