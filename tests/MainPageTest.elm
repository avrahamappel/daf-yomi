module MainPageTest exposing (..)

import Expect
import Main exposing (Msg(..), update)
import Test exposing (..)
import Time exposing (millisToPosix)


tests : Test
tests =
    describe "Main page"
        [ describe "Date switching bug"
            [ test "it flips to the next date when right date button is pressed" <|
                \_ ->
                    let
                        initModel =
                            { date = "today", time = "now" }

                        nextDateModel =
                            update (UpdateTime (millisToPosix 1000)) initModel

                        tick =
                            update nextDateModel
                    in
                    Expect.all
                        [ Expect.equal initModel initModel
                        , Expect.equal nextDateModel { date = "tomorrow" }
                        , Expect.equal tick { date = "tomorrow", time = "+1 second" }
                        ]
            ]
        ]



{-
   current date = tues aug 11 9:50pm
   timezone = toronto
   location = (43.71, -79.40)
   displayed zeman = 9 (chatzos halayla)

   act:
   flip to next date
   assert next date
   update current time by one second
   assert date has not changed
-}
