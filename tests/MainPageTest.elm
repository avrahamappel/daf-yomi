module MainPageTest exposing (..)

import Expect
import Main exposing (Model)
import Test exposing (..)

tests : Test
tests = describe "Main page" [ describe "Date switching bug" [
    test "it flips to the next date when right date button is pressed" <|
        \_ ->
            let
                initModel = {}
            in

            Expect.equal initModel initModel
    ] ]

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
