module Components.Predictions exposing (view)

import Dict exposing (Dict)
import Helpers.Dict
import Helpers.Html
import Helpers.Maybe
import Html exposing (Html)
import Html.Attributes as Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
import Types.PredictionDict
import Types.PredictionResults
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)


type alias Scored a =
    { score : Int
    , value : a
    }


view : Model -> Session -> Html Msg
view model session =
    case Model.getPredictions model session.id of
        Nothing ->
            Helpers.Html.nothing

        Just sessionPredictions ->
            let
                entrants : Dict Types.Entrant.Id Entrant
                entrants =
                    model.entrants
                        |> Dict.get session.id
                        |> Maybe.withDefault []
                        |> Helpers.Dict.fromListWith .id

                viewEntrant : Types.Entrant.Id -> Html Msg
                viewEntrant entrantId =
                    case Dict.get entrantId entrants of
                        Nothing ->
                            Html.text "Unknown driver"

                        Just entrant ->
                            Html.div
                                [ Attributes.class "entrant" ]
                                [ Html.span [ Attributes.class "driver" ] [ Html.text entrant.driver ]
                                , Html.span [ Attributes.class "number" ] [ Helpers.Html.int entrant.number ]
                                , Html.span [ Attributes.class "team" ] [ Html.text entrant.team ]
                                ]

                mResults : Maybe (List Prediction)
                mResults =
                    -- We get the input ones here since we want to score without saving the results to the server.
                    Types.PredictionDict.get Types.PredictionResults.SessionResult session.id model.inputPredictions
                        |> Helpers.Maybe.ifNothing (Maybe.map .predictions sessionPredictions.result)

                viewSessionPrediction : SessionPrediction -> Html Msg -> Html Msg
                viewSessionPrediction sessionPrediction body =
                    Html.li
                        []
                        [ Html.h4 [] [ Html.text sessionPrediction.name ]
                        , body
                        ]

                intCell : Int -> Html msg
                intCell x =
                    Html.td [] [ Helpers.Html.int x ]

                viewPredictionLine : Prediction -> Html Msg -> Html Msg
                viewPredictionLine prediction score =
                    let
                        driver : Html Msg
                        driver =
                            viewEntrant prediction.entrant
                    in
                    Html.tr
                        []
                        [ intCell prediction.position
                        , Html.td [] [ driver ]
                        , score
                        ]
            in
            case mResults of
                Nothing ->
                    let
                        viewPredictions : SessionPrediction -> Html Msg
                        viewPredictions sessionPrediction =
                            let
                                predictionLines : List (Html Msg)
                                predictionLines =
                                    List.map (\p -> viewPredictionLine p Helpers.Html.nothing) sessionPrediction.predictions
                            in
                            Html.table [] [ Html.tbody [] predictionLines ]
                                |> viewSessionPrediction sessionPrediction

                        viewedPredictions : List (Html Msg)
                        viewedPredictions =
                            sessionPredictions.predictions
                                |> Dict.values
                                |> List.map viewPredictions
                    in
                    Html.ul [] viewedPredictions

                Just resultPredictions ->
                    let
                        resultMap : Dict Types.Entrant.Id Prediction
                        resultMap =
                            resultPredictions
                                |> Helpers.Dict.fromListWith .entrant

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
                                                            let
                                                                fastestLap : Int
                                                                fastestLap =
                                                                    case session.fastestLap && prediction.fastestLap && resultLine.fastestLap of
                                                                        False ->
                                                                            0

                                                                        True ->
                                                                            1
                                                            in
                                                            case abs (prediction.position - resultLine.position) of
                                                                0 ->
                                                                    4 + fastestLap

                                                                1 ->
                                                                    2 + fastestLap

                                                                _ ->
                                                                    1 + fastestLap
                                    in
                                    { score = score
                                    , value = viewPredictionLine prediction (intCell score)
                                    }

                                scoredLines : List (Scored (Html Msg))
                                scoredLines =
                                    List.map scoreLine sessionPrediction.predictions
                            in
                            { score = List.map .score scoredLines |> List.sum
                            , value =
                                Html.table [] [ Html.tbody [] (List.map .value scoredLines) ]
                                    |> viewSessionPrediction sessionPrediction
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
