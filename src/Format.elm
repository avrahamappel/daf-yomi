module Format exposing (posixToTimeString)

import Time exposing (Posix)


{-| Format a posix value to a time string
-}
posixToTimeString : Time.Zone -> Posix -> String
posixToTimeString z p =
    let
        hour =
            Time.toHour z p

        minute =
            (if Time.toMillis z p >= 500 then
                1

             else
                0
            )
                + (if Time.toSecond z p >= 30 then
                    1

                   else
                    0
                  )
                + Time.toMinute z p

        pm =
            hour - 12 >= 0

        hour12 =
            if pm then
                hour - 12

            else
                hour

        formattedTime =
            String.fromInt
                (if hour12 == 0 then
                    12

                 else
                    hour12
                )
                ++ ":"
                ++ String.padLeft 2 '0' (String.fromInt minute)
                ++ (if pm then
                        " pm"

                    else
                        " am"
                   )
    in
    formattedTime
