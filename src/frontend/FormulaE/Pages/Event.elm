module FormulaE.Pages.Event exposing (view)

import Components.Username
import Dict
import FormulaE.Event
import FormulaE.Types.Entrant exposing (Entrant)
import FormulaE.Types.RaceInfo
import Helpers.Html
import Helpers.List
import Helpers.Table
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
                , case Dict.get eventId model.formulaERaceInfos of
                    Nothing ->
                        Html.text "There is no race-info for this event."

                    Just raceInfo ->
                        let
                            viewEntrant : Entrant -> List (Html msg)
                            viewEntrant entrant =
                                [ Helpers.Html.int entrant.id
                                , Html.text entrant.name
                                , Html.text " - "
                                , Html.text entrant.team
                                ]

                            createColumnInput : Maybe Entrant -> Html msg
                            createColumnInput mCurrent =
                                let
                                    pleaseSelect : Html msg
                                    pleaseSelect =
                                        Html.option
                                            [ Html.Attributes.value "" ]
                                            [ Html.text "Please select" ]

                                    createOption : Entrant -> Html msg
                                    createOption entrant =
                                        Html.option
                                            [ Html.Attributes.value (String.fromInt entrant.id)
                                            , mCurrent
                                                |> Maybe.map .id
                                                |> Maybe.map ((==) entrant.id)
                                                |> Maybe.withDefault False
                                                |> Html.Attributes.selected
                                            ]
                                            [ Html.text entrant.name ]

                                    options : List (Html msg)
                                    options =
                                        pleaseSelect :: List.map createOption raceInfo.entrants
                                in
                                Html.select
                                    [-- Html.Events.onInput FormulaE.Event.UpdatePrediction
                                    ]
                                    options
                        in
                        Html.section
                            []
                            [ Html.h2 [] [ Html.text "Prediction entry" ]
                            , Html.fieldset
                                []
                                [ createColumnInput Nothing
                                , createColumnInput Nothing
                                ]
                            , case raceInfo.currentPrediction of
                                Nothing ->
                                    Html.text "There is no prediction from the current user yet."

                                Just prediction ->
                                    Html.span
                                        []
                                        [ Html.text "Pole: "
                                        , Helpers.Html.int prediction.pole
                                        , Html.text " - "
                                        , Html.text "Fam: "
                                        , Helpers.Html.int prediction.fam
                                        ]
                            , Html.h2 [] [ Html.text "Results entry" ]
                            , case raceInfo.results of
                                Nothing ->
                                    Html.text "There are no results yet."

                                Just results ->
                                    Html.span
                                        []
                                        [ Html.text "Pole: "
                                        , Helpers.Html.int results.pole
                                        , Html.text " - "
                                        , Html.text "Fam: "
                                        , Helpers.Html.int results.fam
                                        ]
                            , Html.h2 [] [ Html.text "Scores" ]
                            , Helpers.Table.simple
                                { head =
                                    [ Html.tr
                                        []
                                        [ Html.th [] [ Html.text "User" ]
                                        , Html.th [] [ Html.text "Total" ]
                                        , Html.th [] [ Html.text "Pole" ]
                                        , Html.th [] [ Html.text "Fam" ]
                                        ]
                                    ]
                                , body =
                                    let
                                        pointsColumn : Int -> List (Html msg) -> Html msg
                                        pointsColumn score content =
                                            Html.td
                                                []
                                                (List.append
                                                    content
                                                    [ Html.text " : "
                                                    , Helpers.Html.int score
                                                    ]
                                                )

                                        viewColumn : FormulaE.Types.RaceInfo.ScoredColumn -> Html msg
                                        viewColumn column =
                                            viewEntrant column.entrant
                                                |> pointsColumn column.score

                                        viewBool : Bool -> Html msg
                                        viewBool bool =
                                            case bool of
                                                True ->
                                                    Html.text "Yes"

                                                False ->
                                                    Html.text "No"

                                        viewRow : FormulaE.Types.RaceInfo.ScoredPrediction -> Html msg
                                        viewRow scoredPrediction =
                                            Html.tr
                                                []
                                                [ Components.Username.view scoredPrediction.user
                                                    |> Helpers.Table.cell
                                                , Helpers.Table.intCell scoredPrediction.total
                                                , viewColumn scoredPrediction.pole
                                                , viewColumn scoredPrediction.fam
                                                , viewColumn scoredPrediction.fl
                                                , viewColumn scoredPrediction.hgc
                                                , viewColumn scoredPrediction.first
                                                , viewColumn scoredPrediction.second
                                                , viewColumn scoredPrediction.third
                                                , viewColumn scoredPrediction.fdnf
                                                , [ viewBool scoredPrediction.safetyCar ]
                                                    |> pointsColumn scoredPrediction.safetyCarPoints
                                                ]
                                    in
                                    List.map viewRow raceInfo.scoredPredictions
                                }
                            ]
                ]
