module Components.Predictions exposing (view)

import Dict exposing (Dict)
import Helpers.Dict
import Helpers.Html
import Html exposing (Html)
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
import Types.Session
import Types.SessionPrediction exposing (SessionPrediction)


type alias Scored a =
    { score : Int
    , value : a
    }


view : Model -> Types.Session.Id -> Html Msg
view model sessionId =
    case Model.getPredictions model sessionId of
        Nothing ->
            Helpers.Html.nothing

        Just sessionPredictions ->
            case sessionPredictions.result of
                Nothing ->
                    -- TODO: We still want to show the predictions.
                    Html.text "No results in yet."

                Just result ->
                    let
                        resultMap : Dict Types.Entrant.Id Prediction
                        resultMap =
                            result.predictions
                                |> Helpers.Dict.fromListWith .entrant

                        entrants : Dict Types.Entrant.Id Entrant
                        entrants =
                            model.entrants
                                |> Dict.get sessionId
                                |> Maybe.withDefault []
                                |> Helpers.Dict.fromListWith .id

                        viewPredictions : SessionPrediction -> Scored (Html Msg)
                        viewPredictions sessionPrediction =
                            let
                                scoreLine : Prediction -> Scored (Html Msg)
                                scoreLine prediction =
                                    let
                                        mResultLine : Maybe Prediction
                                        mResultLine =
                                            Dict.get prediction.entrant resultMap

                                        score : Int
                                        score =
                                            case mResultLine of
                                                Nothing ->
                                                    0

                                                Just resultLine ->
                                                    case prediction.position <= 10 && resultLine.position <= 10 of
                                                        False ->
                                                            0

                                                        True ->
                                                            case abs (prediction.position - resultLine.position) of
                                                                0 ->
                                                                    4

                                                                1 ->
                                                                    2

                                                                _ ->
                                                                    1
                                        driver : Html Msg
                                        driver =
                                            case Dict.get prediction.entrant entrants of
                                                Nothing ->
                                                    Html.text "Unknown driver"
                                                Just entrant ->
                                                    Html.text entrant.driver
                                        intCell : Int -> Html msg
                                        intCell x =
                                            Html.td [] [ Helpers.Html.int x ]

                                    in
                                    { score = score
                                    , value =
                                        Html.tr
                                            []
                                            [ Html.td
                                                []
                                                [ driver ]
                                            , intCell score
                                            ]
                                    }

                                scoredLines : List (Scored (Html Msg))
                                scoredLines =
                                    List.map scoreLine sessionPrediction.predictions
                            in
                            { score = List.map .score scoredLines |> List.sum
                            , value =
                                Html.li
                                    []
                                    [ Html.h4 [] [ Html.text sessionPrediction.name ]
                                    , Html.table
                                        []
                                        [ Html.tbody [] (List.map .value scoredLines) ]
                                    ]
                            }

                        scoredPredictions : List (Html Msg)
                        scoredPredictions =
                            sessionPredictions.predictions
                                |> Dict.values
                                |> List.map viewPredictions
                                |> List.sortBy .score
                                |> List.reverse
                                |> List.map .value
                    in
                    Html.ul [] scoredPredictions
