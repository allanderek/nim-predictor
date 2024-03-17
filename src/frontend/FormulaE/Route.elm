module FormulaE.Route exposing
    ( Route(..)
    , parser
    , unparse
    )

import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Events


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.s "events"
            |> Parser.map Events
        ]


unparse : Route -> List String
unparse route =
    case route of
        Events ->
            [ "events" ]
