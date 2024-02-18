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


type alias Config =
    { session : Session }


view : Model -> Config -> Html Msg
view model config =
    let
        predictions : List Prediction
        predictions =
            Model.getInputPredictions model config.session.id

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
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (Msg.MovePrediction Msg.Up config.session.id index) ]
                        [ Html.text "Up" ]
                    ]
                , Html.td []
                    [ Html.button
                        [ Html.Events.onClick (Msg.MovePrediction Msg.Down config.session.id index) ]
                        [ Html.text "Down" ]
                    ]
                ]
    in
    Html.section
        []
        [ Html.h2
            []
            [ Html.text config.session.name ]
        , Html.table
            []
            [ Html.tbody [] (List.indexedMap showPrediction predictions) ]
        , Html.button
            [ Html.Events.onClick (Msg.SubmitPredictions config.session.id) ]
            [ Html.text "Submit" ]
        ]
