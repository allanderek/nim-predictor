module Formula1.Route exposing
    ( Route(..)
    , parser
    , unparse
    )

import Types.Event
import Types.Session
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Leaderboard
    | SeasonLeaderboard
    | EventPage Types.Event.Id (Maybe Types.Session.Id)


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.s "leaderboard"
            |> Parser.map Leaderboard
        , Parser.s "seasonleaderboard"
            |> Parser.map SeasonLeaderboard
        , (Parser.s "event" </> Parser.int </> Parser.int)
            |> Parser.map (\eventId sessionId -> EventPage eventId (Just sessionId))
        , (Parser.s "event" </> Parser.int)
            |> Parser.map (\eventId -> EventPage eventId Nothing)
        ]


unparse : Route -> List String
unparse route =
    case route of
        Leaderboard ->
            [ "leaderboard" ]

        SeasonLeaderboard ->
            [ "seasonleaderboard" ]

        EventPage id mSession ->
            List.filter ((/=) "")
                [ "event"
                , String.fromInt id
                , mSession
                    |> Maybe.map String.fromInt
                    |> Maybe.withDefault ""
                ]
