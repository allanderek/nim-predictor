module Components.InputPredictions exposing (view)

import Dict
import Helpers.Html
import Html exposing (Html)
import Html.Events
import List.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Types.Entrant exposing (Entrant)
import Types.Prediction exposing (Prediction)
import Types.Session exposing (Session)
import Types.PredictionResults


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

                toMoveMessage : Msg.UpDown -> Msg
                toMoveMessage =
                    Msg.MovePrediction config.context config.session.id index
            in
            Html.tr
                []
                [ Html.td [] [ Helpers.Html.int prediction.position ]
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
