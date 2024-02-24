module View exposing (view)

import Browser
import Components.InputPredictions
import Components.InputSeasonPredictions
import Components.Predictions
import Components.WorkingIndicator
import Helpers.Html
import Html exposing (Html)
import Html.Attributes as Attributes
import List.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Route exposing (Route)
import Types.Event exposing (Event)
import Types.PredictionResults
import Types.Requests
import Types.Session exposing (Session)


routeHref : Route -> Html.Attribute msg
routeHref route =
    route
        |> Route.unparse
        |> Attributes.href


view : Model -> Browser.Document Msg
view model =
    let
        navBar : Html msg
        navBar =
            Html.nav
                []
                [ Html.ul
                    []
                    [ Html.li
                        []
                        [ Html.a
                            [ routeHref Route.Home ]
                            [ Html.text "Events" ]
                        ]
                    , Html.li
                        []
                        [ case model.user of
                            Nothing ->
                                Html.a
                                    []
                                    [ Html.text "Login" ]

                            Just user ->
                                Html.a
                                    [ routeHref Route.ProfilePage ]
                                    [ Html.text user.fullname ]
                        ]
                    ]
                ]

        main : List (Html Msg)
        main =
            case model.route of
                Route.Home ->
                    viewHome model

                Route.EventPage id ->
                    viewEventPage model id

                Route.ProfilePage ->
                    [ Html.text "Sorry, I've not written a profile page yet." ]

                Route.NotFound ->
                    [ Html.text "Sorry, I do not recognise that page." ]
    in
    { title = "Pole prediction"
    , body = navBar :: main
    }


viewHome : Model -> List (Html Msg)
viewHome model =
    let
        getEventsStatus : Html Msg
        getEventsStatus =
            case model.getEventsStatus of
                Types.Requests.Ready ->
                    Helpers.Html.nothing

                Types.Requests.InFlight ->
                    Html.div
                        []
                        [ Components.WorkingIndicator.view
                        , Html.text "Getting the events."
                        ]

                Types.Requests.Succeeded ->
                    Helpers.Html.nothing

                Types.Requests.Failed ->
                    Html.text "The request to get the events failed."

        showEvent : Event -> Html Msg
        showEvent event =
            Html.tr
                []
                [ Html.td [] [ String.fromInt event.round |> Html.text ]
                , Html.td []
                    [ Html.a
                        [ Route.EventPage event.id
                            |> routeHref
                        ]
                        [ Html.text event.name ]
                    ]
                ]
    in
    [ getEventsStatus
    , Html.table
        [ Attributes.class "event-list" ]
        [ Html.tbody [] (List.map showEvent model.events)
        ]

    -- Of course this should show results if the season has started.
    , Components.InputSeasonPredictions.view model
    ]


viewEventPage : Model -> Types.Event.Id -> List (Html Msg)
viewEventPage model eventId =
    case List.Extra.find (\event -> event.id == eventId) model.events of
        Nothing ->
            -- TODO: It should check if we are downloading the events.
            [ Html.text "Event not found" ]

        Just event ->
            let
                sessions : List (Html Msg)
                sessions =
                    List.filter (\session -> session.event == eventId) model.sessions
                        |> List.map (showSession model)
            in
            [ Html.h2
                []
                [ Html.text event.name ]
            , Html.node "main" [] sessions
            ]


showSession : Model -> Session -> Html Msg
showSession model session =
    let
        -- TODO: Of course there are conditions on each of these, such that you should only see at most one.
        -- 1. Enter predictions if logged-in and the session hasn't yet started.
        -- 2. Enter results if logged-in, as an admin-user, and the session has started.
        input : Html Msg
        input =
            case model.user of
                Nothing ->
                    Helpers.Html.nothing

                Just user ->
                    Html.div
                        []
                        [ Components.InputPredictions.view model
                            { context = Types.PredictionResults.UserPrediction user.id
                            , session = session
                            }
                        , Components.InputPredictions.view model
                            { context = Types.PredictionResults.SessionResult
                            , session = session
                            }
                        ]

        scores : Html Msg
        scores =
            Components.Predictions.view model session
    in
    Html.section
        []
        [ Html.h2
            []
            [ Html.text session.name ]
        , input
        , scores
        ]
