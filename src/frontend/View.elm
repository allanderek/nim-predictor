module View exposing (view)

import Browser
import Helpers.Html
import Html exposing (Html)
import Html.Attributes as Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Event exposing (Event)
import Types.Requests


view : Model -> Browser.Document Msg
view model =
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
                , Html.td [] [ Html.text event.name ]
                ]
    in
    { title = "Pole prediction"
    , body =
        [ getEventsStatus
        , Html.table
            [ Attributes.class "event-list" ]
            [ Html.tbody [] (List.map showEvent model.events)
            ]
        ]
    }
