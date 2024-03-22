module FormulaE.Route exposing
    ( Route(..)
    , parser
    , unparse
    )

import Url.Parser as Parser exposing ((</>), Parser)
import FormulaE.Event 


type Route
    = Events
    | EventPage FormulaE.Event.Id


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.s "events"
            |> Parser.map Events
        , (Parser.s "event" </> Parser.int)
            |> Parser.map EventPage
        ]


unparse : Route -> List String
unparse route =
    case route of
        Events ->
            [ "events" ]

        EventPage id ->
            [ "event", String.fromInt id ]
