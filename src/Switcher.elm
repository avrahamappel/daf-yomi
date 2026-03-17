module Switcher exposing (SwitcherMsg(..), switcher)

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
