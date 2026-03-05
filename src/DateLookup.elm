module DateLookup exposing (Model)

import Time exposing (Month)


type alias EnglishMonth =
    Month


type HebrewMonth
    = Nissan
    | Iyar
    | Sivan
    | Tammuz
    | Av
    | Elul
    | Tishrei
    | Cheshvan
    | Kislev
    | Teves
    | Shvat
    | Adar1
    | Adar2


type Model
    = EnglishDate { year : Int, month : EnglishMonth, day : Int }
    | HebrewDate { year : Int, month : HebrewMonth, day : Int }
