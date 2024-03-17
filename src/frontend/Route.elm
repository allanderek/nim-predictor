module Route exposing
    ( Route(..)
    , parse
    , unparse
    )

import Formula1.Route
import FormulaE.Route
import Url
import Url.Builder
import Url.Parser as Parser exposing ((</>))


type Route
    = Home
    | ProfilePage
    | Formula1 Formula1.Route.Route
    | FormulaE FormulaE.Route.Route
    | NotFound


parse : Url.Url -> Route
parse url =
    let
        routeParser =
            Parser.oneOf
                [ Parser.top |> Parser.map Home
                , Parser.s "formulaone" </> Formula1.Route.parser |> Parser.map Formula1
                , Parser.s "formulae" </> FormulaE.Route.parser |> Parser.map FormulaE
                , Parser.map ProfilePage (Parser.s "formulaone" </> Parser.s "profile")
                ]
    in
    url
        |> Parser.parse routeParser
        |> Maybe.withDefault NotFound


unparse : Route -> String
unparse route =
    let
        parts : List String
        parts =
            case route of
                Home ->
                    []

                Formula1 subRoute ->
                    "formulaone" :: Formula1.Route.unparse subRoute

                ProfilePage ->
                    [ "profile" ]

                FormulaE subRoute ->
                    "formulae" :: FormulaE.Route.unparse subRoute

                NotFound ->
                    [ "notfound" ]
    in
    Url.Builder.absolute parts []
