module Components.Predictions exposing (view)

import Components.Symbols
import Components.Username
import Dict exposing (Dict)
import Helpers.Classes
import Helpers.Dict
import Helpers.Html
import Helpers.Maybe
import Helpers.Table
import Html exposing (Html)
import Html.Attributes as Attributes
import List.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
import Types.PredictionDict
import Types.PredictionResults
import Types.Scored exposing (Scored)
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)


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

                mResults : Maybe (List Prediction)
                mResults =
                    -- We get the input ones here since we want to score without saving the results to the server.
                    Types.PredictionDict.get Types.PredictionResults.SessionResult session.id model.inputPredictions
                        |> Helpers.Maybe.withMaybeDefault (Maybe.map .predictions sessionPredictions.result)

                viewSessionPrediction : SessionPrediction -> Maybe Int -> Html Msg -> Html Msg
                viewSessionPrediction sessionPrediction mScore body =
                    Html.li
                        []
                        [ Html.h4 []
                            [ Components.Username.view { id = sessionPrediction.user, fullname = sessionPrediction.name }
                            , Helpers.Html.nbsp
                            , case mScore of
                                Nothing ->
                                    Helpers.Html.nothing

                                Just score ->
                                    Html.span [] [ Helpers.Html.int score ]
                            ]
                        , body
                        ]

                viewEntrant : String -> Prediction -> Html Msg
                viewEntrant class prediction =
                    case Dict.get prediction.entrant entrants of
                        Nothing ->
                            Html.text "Unknown driver"

                        Just entrant ->
                            Html.div
                                [ Attributes.class class ]
                                [ Html.span [ Attributes.class "driver" ] [ Html.text entrant.driver ]
                                , Html.span [ Attributes.class "number" ] [ Helpers.Html.int entrant.number ]
                                , Html.span [ Attributes.class "team" ] [ Html.text entrant.team ]
                                , case session.fastestLap && prediction.fastestLap of
                                    False ->
                                        Helpers.Html.nothing

                                    True ->
                                        Html.span [ Attributes.class "fastest-lap" ] [ Components.Symbols.stopWatch ]
                                ]

                viewPredictionLine : Prediction -> Maybe Prediction -> Html Msg -> Html Msg
                viewPredictionLine prediction mResultLine score =
                    let
                        driver : Html Msg
                        driver =
                            Html.td
                                []
                                [ viewEntrant "prediction-driver" prediction
                                , mResultLine
                                    |> Maybe.map (viewEntrant "result-driver")
                                    |> Helpers.Html.maybe
                                ]
                    in
                    Html.tr
                        [ Helpers.Classes.topTenClass prediction.position ]
                        [ Helpers.Table.intCell prediction.position
                        , driver
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
                                    List.map (\p -> viewPredictionLine p Nothing Helpers.Html.nothing) sessionPrediction.predictions
                            in
                            Html.table [] [ Html.tbody [] predictionLines ]
                                |> viewSessionPrediction sessionPrediction Nothing

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
                                        mDriverResultLine : Maybe Prediction
                                        mDriverResultLine =
                                            Dict.get prediction.entrant resultMap

                                        mPositionResultLine : Maybe Prediction
                                        mPositionResultLine =
                                            List.Extra.find (\p -> p.position == prediction.position) resultPredictions

                                        score : Int
                                        score =
                                            case mDriverResultLine of
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
                                    , value = viewPredictionLine prediction mPositionResultLine (Helpers.Table.intCell score)
                                    }

                                scoredLines : List (Scored (Html Msg))
                                scoredLines =
                                    List.map scoreLine sessionPrediction.predictions

                                totalScore : Int
                                totalScore =
                                    Types.Scored.total scoredLines
                            in
                            { score = totalScore
                            , value =
                                Html.table [] [ Html.tbody [] (List.map .value scoredLines) ]
                                    |> viewSessionPrediction sessionPrediction (Just totalScore)
                            }

                        scoredPredictions : List (Html Msg)
                        scoredPredictions =
                            sessionPredictions.predictions
                                |> Dict.values
                                |> List.map viewPredictions
                                |> Types.Scored.sortHighestFirst
                                |> Types.Scored.values
                    in
                    Html.ul [] scoredPredictions
