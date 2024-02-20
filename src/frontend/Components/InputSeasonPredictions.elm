module Components.InputSeasonPredictions exposing (view)

import Components.RequestButton
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
            let
                moveButton : Bool -> Msg.UpDown -> String -> Html Msg
                moveButton visible direction face =
                    Html.td
                        []
                        [ case visible of
                            False ->
                                Helpers.Html.nothing

                            True ->
                                Html.button
                                    [ Msg.MoveSeasonPrediction index direction
                                        |> Html.Events.onClick
                                    ]
                                    [ Html.text face ]
                        ]
            in
            Html.tr
                []
                [ Html.td [] [ Helpers.Html.int (index + 1) ]
                , Html.td [] [ Html.text team.shortname ]
                , moveButton (index >= 1) Msg.Up "Up"
                , moveButton (index < List.length currentPredictions - 1) Msg.Up "Up"
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
        , Components.RequestButton.view
            { status = model.submitSeasonPredictionsStatus
            , disabled = False
            , message = Msg.SubmitSeasonPredictions
            , face = Html.text "Submit"
            }
        ]
