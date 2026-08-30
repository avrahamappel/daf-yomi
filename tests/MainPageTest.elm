module MainPageTest exposing (..)

import Array
import Data exposing (ZemanimState(..))
import Expect
import Main exposing (Model, Msg(..), Page(..), State(..), SwitcherMsg(..), update)
import Settings exposing (LocationMethod(..))
import Test exposing (..)
import Time exposing (Zone, customZone, millisToPosix)


timezone : Zone
timezone =
    customZone -240 []


currentTime : Int
currentTime =
    1786937248405


initModel : Model
initModel =
    { curShiurIndex = 0
    , curTime = currentTime
    , curZemanIndex = 0
    , dispTime = currentTime
    , hasUserNavigated = False
    , page = Main
    , settings =
        { candleLightingMinutes = 15
        , latitude = Nothing
        , locationMethod = Ip
        , longitude = Nothing
        , showPlag = False
        }
    , state =
        HasData
            { date = "Sun Aug 16 2026"
            , hdate = "ג׳ אלול תשפ״ו"
            , parsha = "פרשת כי־תצא"
            , shiurim = Array.fromList []
            , zemanimState =
                HasZemanim
                    { latitude = "43.65"
                    , locationName = Nothing
                    , longitude = "-79.38"
                    , zemanim =
                        Array.fromList
                            [ { name = "חצות הלילה", value = millisToPosix 1786857729500 }
                            , { name = "עלות השחר", value = millisToPosix 1786871460000 }
                            , { name = "הנץ החמה", value = millisToPosix 1786875800000 }
                            , { name = "סו״ז קריאת שמע", value = millisToPosix 1786886181750 }
                            , { name = "סו״ז תפילה (גר\"א)", value = millisToPosix 1786892522000 }
                            , { name = "חצות היום", value = millisToPosix 1786900883000 }
                            , { name = "מנחה גדולה", value = millisToPosix 1786903333791 }
                            , { name = "מנחה קטנה", value = millisToPosix 1786918035541 }
                            , { name = "שקיעת החמה", value = millisToPosix 1786925967000 }
                            , { name = "צאת הכוכבים", value = millisToPosix 1786930260000 }
                            ]
                    }
            }
            { altitude = Nothing
            , latitude = 43.65366
            , longitude = -79.38292
            , name = Nothing
            }
    , timezone = timezone
    }


tests : Test
tests =
    describe "Main page"
        [ describe "Date switching bug"
            [ test "it flips to the next date when right date button is pressed" <|
                \_ ->
                    let
                        ( nextDateModel, _ ) =
                            update (ChangeDate Right) initModel
                    in
                    Expect.equal nextDateModel.dispTime 1787023648405

            , test "it remains on the next date after the time is adjusted" <|
                \_ ->
                    let
                        adjustedTimeNextDateModel =
                            initModel
                                |> update (ChangeDate Right)
                                |> Tuple.first
                                |> update (AdjustTime timezone (millisToPosix (currentTime + 1000)))
                                |> Tuple.first
                    in
                    Expect.equal adjustedTimeNextDateModel.dispTime 1787023648405
            ]
        ]
