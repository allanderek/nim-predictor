module Helpers.Html exposing
    ( int
    , maybe
    , nbsp
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


nbsp : Html msg
nbsp =
    Html.text "\u{00A0}"
