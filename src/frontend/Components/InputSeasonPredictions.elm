module Components.InputSeasonPredictions exposing (view)

import Helpers.Html
import Html exposing (Html)
import Html.Events
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Team exposing (Team)


view : Model -> Html Msg
view model =
    let
        currentPredictions : List Team
        currentPredictions =
            Model.getSeasonInputPredictions model

        showTeam : Int -> Team -> Html Msg
        showTeam index team =
            Html.tr
                []
                [ Html.td [] [ Helpers.Html.int (index + 1) ]
                , Html.td [] [ Html.text team.shortname ]
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (Msg.MoveSeasonPrediction index Msg.Up) ]
                        [ Html.text "Up" ]
                    ]
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (Msg.MoveSeasonPrediction index Msg.Down) ]
                        [ Html.text "Down" ]
                    ]
                ]
    in
    Html.section
        []
        [ Html.table
            []
            [ Html.tbody
                []
                (List.indexedMap showTeam currentPredictions)
            ]
        , Html.button
            [ Html.Events.onClick Msg.SubmitSeasonPredictions  ]
            [ Html.text "Submit" ]
        ]
