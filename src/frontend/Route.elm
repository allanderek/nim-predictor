module Route exposing
    ( Route(..)
    , parse
    , unparse
    )

import Types.Event
import Types.Session
import Url
import Url.Builder
import Url.Parser as Parser exposing ((</>))


type Route
    = Home
    | Leaderboard
    | EventPage Types.Event.Id (Maybe Types.Session.Id)
    | ProfilePage
    | NotFound


parse : Url.Url -> Route
parse url =
    let
        routeParser =
            Parser.oneOf
                [ Parser.top |> Parser.map Home
                , Parser.s "formulaone" |> Parser.map Home
                , Parser.map Leaderboard (Parser.s "formulaone" </> Parser.s "leaderboard")
                , Parser.map
                    (\eventId sessionId -> EventPage eventId (Just sessionId))
                    (Parser.s "formulaone" </> Parser.s "event" </> Parser.int </> Parser.int)
                , Parser.map
                    (\eventId -> EventPage eventId Nothing)
                    (Parser.s "formulaone" </> Parser.s "event" </> Parser.int)
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

                Leaderboard ->
                    [ "leaderboard" ]

                EventPage id mSession ->
                    List.filter ((/=) "") 
                        [ "event"
                        , String.fromInt id 
                        , mSession
                            |> Maybe.map String.fromInt
                            |> Maybe.withDefault ""
                        ]

                ProfilePage ->
                    [ "profile" ]

                NotFound ->
                    [ "notfound" ]
    in
    Url.Builder.absolute ("formulaone" :: parts) []
