module Helpers.Table exposing
    ( intCell
    , stringCell
    , stringHeaderCell
    )

import Helpers.Html
import Html exposing (Html)


intCell : Int -> Html msg
intCell x =
    Html.td [] [ Helpers.Html.int x ]


stringCell : String -> Html msg
stringCell s =
    Html.td [] [ Html.text s ]


stringHeaderCell : String -> Html msg
stringHeaderCell s =
    Html.th [] [ Html.text s ]
