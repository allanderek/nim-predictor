module Helpers.Html exposing
    ( int
    , maybe
    , nbsp
    , nothing
    , wrapped
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


wrapped : (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> Html msg -> Html msg
wrapped nodeFun content =
    nodeFun [] [ content ]
