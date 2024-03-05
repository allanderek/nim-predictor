module Helpers.Table exposing
    ( cell
    , intCell
    , stringCell
    , stringHeaderCell
    )

import Helpers.Html
import Html exposing (Html)


cell : Html msg -> Html msg
cell content =
    Html.td [] [ content ]


intCell : Int -> Html msg
intCell x =
    Helpers.Html.int x
        |> cell


stringCell : String -> Html msg
stringCell s =
    Html.text s
        |> cell


headerCell : Html msg -> Html msg
headerCell content =
    Html.th [] [ content ]


stringHeaderCell : String -> Html msg
stringHeaderCell s =
    Html.text s
        |> headerCell
