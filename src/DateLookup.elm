port module DateLookup exposing (Model, init, subscriptions, update, view)

import Html exposing (Html, div, text)



-- PORTS


port lookupHebrewMonths : String -> Cmd msg


port lookupHebrewMonthsResponse : (List String -> msg) -> Sub msg


port lookupHebrewDays : ( String, String ) -> Cmd msg


port lookupHebrewDaysResponse : (List String -> msg) -> Sub msg


port lookupEnglishDays : ( String, String ) -> Cmd msg


port lookupEnglishDaysResponse : (List String -> msg) -> Sub msg


port lookupHebrewTimestamp : Selected -> Cmd msg


port lookupEnglishTimestamp : Selected -> Cmd msg


port lookupTimestampResponse : (Int -> msg) -> Sub msg



-- MODEL


type alias Model =
    { loading : Bool
    , calendar : Calendar
    , options : Options
    , selected : Selected
    }


type Calendar
    = English
    | Hebrew


type alias Options =
    { years : List String
    , months : List String
    , days : List String
    }


type alias Selected =
    { year : String
    , month : String
    , day : String
    }


init : Selected -> ( Model, Cmd Msg )
init selected =
    let
        _ =
            Debug.todo "Receive timestamp and convert to date (do we need another port / ports for this?)"
    in
    ( { loading = False
      , calendar = Hebrew
      , options =
            { years = Debug.todo "unix start to unix end"
            , months = Debug.todo "all months"
            , days = []
            }
      , selected = selected
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ lookupHebrewMonthsResponse SetHebrewMonths
        , lookupHebrewDaysResponse SetHebrewDays
        , lookupEnglishDaysResponse SetEnglishDays
        , lookupTimestampResponse SetTimestamp
        ]



-- EVENTS


type Msg
    = SwitchCalendar Calendar
    | ChooseYear String
    | ChooseMonth String
    | ChooseDay String
    | SetHebrewMonths (List String)
    | SetHebrewDays (List String)
    | SetEnglishDays (List String)
    | SetTimestamp Int
    | Close
    | Lookup


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        selected =
            model.selected

        options =
            model.options
    in
    case msg of
        SwitchCalendar calendar ->
            ( { model | calendar = calendar }, Cmd.none )

        ChooseYear year ->
            let
                newModel =
                    { model | selected = { selected | year = year } }
            in
            case model.calendar of
                English ->
                    ( newModel, Cmd.none )

                Hebrew ->
                    ( newModel, lookupHebrewMonths year )

        ChooseMonth month ->
            let
                newModel =
                    { model | selected = { selected | month = month } }
            in
            case model.calendar of
                English ->
                    ( newModel, lookupEnglishDays ( selected.year, month ) )

                Hebrew ->
                    ( newModel, lookupHebrewDays ( selected.year, month ) )

        ChooseDay day ->
            ( { model | selected = { selected | day = day } }, Cmd.none )

        SetHebrewMonths months ->
            case model.calendar of
                English ->
                    ( model, Cmd.none )

                Hebrew ->
                    ( { model | options = { options | months = months } }, Cmd.none )

        SetHebrewDays days ->
            case model.calendar of
                English ->
                    ( model, Cmd.none )

                Hebrew ->
                    ( { model | options = { options | days = days } }, Cmd.none )

        SetEnglishDays days ->
            case model.calendar of
                English ->
                    ( { model | options = { options | days = days } }, Cmd.none )

                Hebrew ->
                    ( model, Cmd.none )

        SetTimestamp _ ->
            Debug.todo "parent set page = Main, set timestamp to t and lookup data"

        Close ->
            Debug.todo "parent set page = Main"

        Lookup ->
            let
                newModel =
                    { model | loading = True }
            in
            case model.calendar of
                English ->
                    ( newModel, lookupEnglishTimestamp model.selected )

                Hebrew ->
                    ( newModel, lookupHebrewTimestamp model.selected )



-- VIEW


view : Model -> Html Msg
view model =
    if model.loading then
        div [] [ text "Loading..." ]

    else
        Debug.todo "implement view"



{-
   +--------+---------+
   | Hebrew | English | -> triggers SwitchCalendar
   +--------+---------+

   if Hebrew:

   +-----+ +---------+ +--------+
   | yom | | chodesh | | shanah |
   +-----+ +---------+ +--------+

   if English:

   +------+ +-------+ +-----+
   | year | | month | | day |
   +------+ +-------+ +-----+

   +------+--------------+
   | Back | Look up date |
   +------+--------------+
-}
