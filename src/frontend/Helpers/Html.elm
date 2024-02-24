module Helpers.Html exposing
    ( int
    , maybe
    , nothing
    )

import Html exposing (Html)


nothing : Html msg
nothing =
    Html.text ""


maybe : Maybe (Html msg) -> Html msg
maybe mHtml =
    Maybe.withDefault nothing mHtml


int : Int -> Html msg
int i =
    String.fromInt i
        |> Html.text
