module Route exposing
    ( Route
    , parse
    , unparse
    )

import Url
import Url.Builder
import Url.Parser as Parser exposing ((</>))


type Route
    = Home


parse : Url.Url -> Route
parse url =
    let
        routeParser =
            Parser.oneOf
                [ Parser.top |> Parser.map Home ]
    in
    url
        |> Parser.parse routeParser
        |> Maybe.withDefault Home


unparse : Route -> String
unparse route =
    let
        parts : List String
        parts =
            case route of
                Home ->
                    []
    in
    Url.Builder.absolute parts []
