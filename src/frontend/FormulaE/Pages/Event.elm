module FormulaE.Pages.Event exposing (view)

import FormulaE.Event
import Helpers.Html
import Helpers.List
import Helpers.Time
import Html exposing (Html)
import Html.Attributes
import Model exposing (Model)


view : Model -> FormulaE.Event.Id -> Html msg
view model eventId =
    case Helpers.List.findBy .id eventId model.formulaEEvents of
        Nothing ->
            Html.text "Sorry event not found."

        Just event ->
            Html.node "main"
                []
                [ Html.h1
                    []
                    [ Helpers.Html.int event.round
                    , Html.text " - "
                    , Html.text event.name
                    ]
                , Html.p [] [ Html.text event.country ]
                , Html.p [] [ Html.text event.circuit ]
                , Html.p []
                    [ Helpers.Time.showPosix model.zone event.startTime
                        |> Html.text
                    ]
                ]
