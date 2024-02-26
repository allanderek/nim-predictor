module Components.InputPredictions exposing (view)

import Components.Button
import Components.Symbols
import Dict
import Helpers.Attributes
import Helpers.Html
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
import Types.Requests
import Types.Session exposing (Session)


type alias Config =
    { session : Session
    , context : Types.PredictionResults.Key
    }


view : Model -> Config -> Html Msg
view model config =
    let
        predictions : List Prediction
        predictions =
            Model.getInputPredictions model config.context config.session.id

        entrants : List Entrant
        entrants =
            Dict.get config.session.id model.entrants
                |> Maybe.withDefault []

        getEntrant : Types.Entrant.Id -> Maybe Entrant
        getEntrant entrantId =
            List.Extra.find (\entrant -> entrant.id == entrantId) entrants

        inputResultsWarning : Html msg
        inputResultsWarning =
            case config.context of
                Types.PredictionResults.UserPrediction _ ->
                    Helpers.Html.nothing

                Types.PredictionResults.SessionResult ->
                    Html.p
                        []
                        [ Html.text "You are inputting the results" ]

        fastestLapWarning : Html msg
        fastestLapWarning =
            case config.session.fastestLap of
                False ->
                    Helpers.Html.nothing

                True ->
                    case List.any .fastestLap predictions of
                        True ->
                            Helpers.Html.nothing

                        False ->
                            Html.p
                                [ Attributes.class "fastest-lap-warning" ]
                                [ Html.text "Do not forget to select a fastest lap." ]

        showPrediction : Int -> Prediction -> Html Msg
        showPrediction index prediction =
            let
                mEntrant : Maybe Entrant
                mEntrant =
                    getEntrant prediction.entrant

                toEditMessage : Msg.EditPredictions -> Msg
                toEditMessage =
                    Msg.EditPredictions config.context config.session.id

                moveButton : Msg.UpDown -> Bool -> Html Msg
                moveButton upDown disabled =
                    Html.button
                        [ Msg.MovePrediction index upDown
                            |> toEditMessage
                            |> Helpers.Attributes.disabledOrOnClick disabled
                        ]
                        [ case upDown of
                            Msg.Up ->
                                Components.Symbols.upArrow

                            Msg.Down ->
                                Components.Symbols.downArrow
                        ]
            in
            Html.tr
                []
                [ Helpers.Table.intCell prediction.position
                , case config.session.fastestLap of
                    False ->
                        Helpers.Html.nothing

                    True ->
                        Html.td []
                            [ case prediction.fastestLap of
                                True ->
                                    Html.span
                                        [ Attributes.class "predicted-fastest-lap" ]
                                        [ Components.Symbols.stopWatch ]

                                False ->
                                    Html.button
                                        [ Msg.FastestLapPrediction index
                                            |> toEditMessage
                                            |> Helpers.Attributes.disabledOrOnClick (prediction.position > 10)
                                        ]
                                        [ Components.Symbols.stopWatch ]
                            ]
                , Html.td []
                    [ case mEntrant of
                        Nothing ->
                            Html.text "-"

                        Just entrant ->
                            Helpers.Html.int entrant.number
                    ]
                , Html.td []
                    [ case mEntrant of
                        Nothing ->
                            Html.text "Unknown driver"

                        Just entrant ->
                            Html.text entrant.driver
                    ]
                , Html.td []
                    [ case mEntrant of
                        Nothing ->
                            Html.text "Unknown team"

                        Just entrant ->
                            Html.text entrant.team
                    ]
                , Html.td [] [ moveButton Msg.Up (index == 0) ]
                , Html.td [] [ moveButton Msg.Down (index >= List.length predictions - 1) ]
                ]

        requestStatus : Types.Requests.Status
        requestStatus =
            Types.PredictionDict.get config.context config.session.id model.submitPredictionsStatus
                |> Maybe.withDefault Types.Requests.Ready

        requestInFlight : Bool
        requestInFlight =
            Types.Requests.isInFlight requestStatus

        submitDisabled : Bool
        submitDisabled =
            requestInFlight
    in
    Html.section
        [ case config.context of
            Types.PredictionResults.UserPrediction _ ->
                Attributes.class "input-predictions-section"

            Types.PredictionResults.SessionResult ->
                Attributes.class "input-results-section"
        ]
        [ inputResultsWarning
        , fastestLapWarning
        , Html.table
            []
            [ Html.tbody [] (List.indexedMap showPrediction predictions) ]
        , Html.button
            [ Msg.SubmitPredictions config.context config.session.id
                |> Helpers.Attributes.disabledOrOnClick submitDisabled
            ]
            [ Html.text "Submit"
                |> Components.Button.faceOrWorking requestStatus
            ]
        ]
