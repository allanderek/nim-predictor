module Route exposing
    ( Route(..)
    , parse
    , unparse
    )

import Types.Event
import Url
import Url.Builder
import Url.Parser as Parser exposing ((</>))


type Route
    = Home
    | EventPage Types.Event.Id
    | NotFound


parse : Url.Url -> Route
parse url =
    let
        routeParser =
            Parser.oneOf
                [ Parser.s "formulaone" |> Parser.map Home
                , Parser.map EventPage (Parser.s "formulaone" </> Parser.s "event" </> Parser.int)
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

                EventPage id ->
                    [ "event", String.fromInt id ]

                NotFound ->
                    [ "notfound" ]
    in
    Url.Builder.absolute ("formulaone" :: parts) []
