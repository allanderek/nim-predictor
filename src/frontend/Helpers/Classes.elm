module Helpers.Classes exposing (topTenClass)

import Html
import Html.Attributes as Attributes


topTenClass : Int -> Html.Attribute msg
topTenClass position =
    case position <= 10 of
        True ->
            Attributes.class "in-top-ten"

        False ->
            Attributes.class "not-in-top-ten"
