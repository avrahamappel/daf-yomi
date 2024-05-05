module Format exposing (posixToTimeString)

import DateFormat
import Time exposing (Posix)


{-| Format a posix value to a time string
-}
posixToTimeString : Time.Zone -> Posix -> String
posixToTimeString z p =
    DateFormat.format
        [ DateFormat.hourNumber
        , DateFormat.text ":"
        , DateFormat.minuteFixed
        , DateFormat.text " "
        , DateFormat.amPmLowercase
        ]
        z
        p
