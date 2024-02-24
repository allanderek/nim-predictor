module Components.InputPredictions exposing (view)

import Dict
import Helpers.Attributes
import Helpers.Html
import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events
import List.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
import Types.PredictionResults
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

        showPrediction : Int -> Prediction -> Html Msg
        showPrediction index prediction =
            let
                mEntrant : Maybe Entrant
                mEntrant =
                    getEntrant prediction.entrant

                toEditMessage : Msg.EditPredictions -> Msg
                toEditMessage =
                    Msg.EditPredictions config.context config.session.id

                toMoveMessage : Msg.UpDown -> Msg
                toMoveMessage upDown =
                    Msg.MovePrediction index upDown
                        |> toEditMessage
            in
            Html.tr
                []
                [ Html.td [] [ Helpers.Html.int prediction.position ]
                , case config.session.fastestLap of
                    False ->
                        Helpers.Html.nothing

                    True ->
                        Html.td []
                            [ case prediction.fastestLap of
                                True ->
                                    Html.span
                                        [ Attributes.class "predicted-fastest-lap" ]
                                        [ Html.text "FL" ]

                                False ->
                                    Html.button
                                        [ Msg.FastestLapPrediction index
                                            |> toEditMessage
                                            |> Helpers.Attributes.disabledOrOnClick (prediction.position > 10)
                                        ]
                                        [ Html.text "FL" ]
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

                -- TODO: These should be disabled in the obvious cases.
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (toMoveMessage Msg.Up) ]
                        [ Html.text "Up" ]
                    ]
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (toMoveMessage Msg.Down) ]
                        [ Html.text "Down" ]
                    ]
                ]
    in
    Html.section
        []
        [ Html.table
            []
            [ Html.tbody [] (List.indexedMap showPrediction predictions) ]
        , Html.button
            [ Html.Events.onClick (Msg.SubmitPredictions config.context config.session.id) ]
            [ Html.text "Submit" ]
        ]
