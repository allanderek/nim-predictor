module Components.InputSeasonPredictions exposing (view)

import Components.RequestButton
import Helpers.Html
import Helpers.Table
import Helpers.Time
import Html exposing (Html)
import Html.Events
import Model exposing (Model)
import Msg exposing (Msg)
import Time
import Types.Team exposing (Team)
import Components.Symbols


view : Model -> Time.Posix -> Html Msg
view model seasonStarting =
    let
        currentPredictions : List Team
        currentPredictions =
            Model.getSeasonInputPredictions model

        showTeam : Int -> Team -> Html Msg
        showTeam index team =
            let
                moveButton : Bool -> Msg.UpDown -> Html Msg -> Html Msg
                moveButton visible direction face =
                    Html.td []
                        [ case visible of
                            False ->
                                Helpers.Html.nothing

                            True ->
                                Html.button
                                    [ Msg.MoveSeasonPrediction index direction
                                        |> Html.Events.onClick
                                    ]
                                    [ face ]
                        ]
            in
            Html.tr
                []
                [ Helpers.Table.intCell (index + 1)
                , Helpers.Table.stringCell team.shortname
                , moveButton (index >= 1) Msg.Up Components.Symbols.upArrow
                , moveButton (index < List.length currentPredictions - 1) Msg.Down Components.Symbols.downArrow
                ]
    in
    Html.section
        []
        [ Html.p
            []
            [ Html.text "Enter predictions by: "
            , Helpers.Time.showPosix model.zone seasonStarting
                |> Html.text
            ]
        , Html.table
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
