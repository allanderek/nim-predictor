module Components.Predictions exposing (view)

import Dict exposing (Dict)
import Helpers.Dict
import Helpers.Html
import Html exposing (Html)
import Html.Attributes as Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
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
            in
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

                                        driver : Html Msg
                                        driver =
                                            viewEntrant prediction.entrant

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
