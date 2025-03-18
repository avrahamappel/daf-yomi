module UpdateTests exposing (tests)

import Expect
import Json.Encode
import Main exposing (Model, Msg(..), update)
import Settings
import Test exposing (..)
import Time



-- Example initial model for testing


initialModel : Model
initialModel =
    { curTime = 0
    , curShiurIndex = 0
    , curZemanIndex = 0
    , dispTime = 0
    , timezone = Time.utc
    , page = Main.Main
    , state = Main.LoadingData
    , settings = Settings.decode (Json.Encode.object [])
    }



-- Test the AdjustTime message


testAdjustTime : Test
testAdjustTime =
    let
        -- Create a model with initial values
        model =
            initialModel

        -- Define the message to test
        msg =
            AdjustTime Time.utc (Time.millisToPosix 1000)

        -- Apply the update function
        ( updatedModel, _ ) =
            update msg model
    in
    test "AdjustTime updates the model correctly" <|
        \_ ->
            Expect.equal updatedModel.curTime 1000



-- Define the list of tests


tests : Test
tests =
    describe "Update function tests"
        [ testAdjustTime
        ]
