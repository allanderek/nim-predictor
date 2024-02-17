module View exposing (view)

import Dict
import Types.Entrant exposing (Entrant)
import Browser
import Helpers.Html
import Html exposing (Html)
import Html.Attributes as Attributes
import List.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Route
import Types.Event exposing (Event)
import Types.Requests
import Types.Session exposing (Session)


view : Model -> Browser.Document Msg
view model =
    { title = "Pole prediction"
    , body =
        case model.route of
            Route.Home ->
                viewHome model

            Route.EventPage id ->
                viewEventPage model id

            Route.NotFound ->
                [ Html.text "Sorry, I do not recognise that page." ]
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
                    Html.text "Working"

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
                            |> Route.unparse
                            |> Attributes.href
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
        entrants : List Entrant
        entrants =
            Dict.get session.id model.entrants
                |> Maybe.withDefault []

        showEntrant : Entrant -> Html Msg
        showEntrant entrant =
            Html.tr
                []
                [ Html.td [] [ Html.text (String.fromInt entrant.number) ]
                , Html.td [] [ Html.text entrant.driver ]
                , Html.td [] [ Html.text entrant.team ]
                ]

    in
    Html.section
        []
        [ Html.h2
            []
            [ Html.text session.name ]
        , Html.table 
            [] 
            [ Html.tbody [] (List.map showEntrant entrants) ]
        ]
