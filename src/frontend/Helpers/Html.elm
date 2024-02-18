module Helpers.Html exposing
    ( int
    , nothing
    )

import Html exposing (Html)


nothing : Html msg
nothing =
    Html.text ""


int : Int -> Html msg
int i =
    String.fromInt i
        |> Html.text
