module FormulaE.Types.RaceInfo exposing
    ( RaceInfo
    , ScoredColumn
    , ScoredPrediction
    , decoder
    )

import Types.User
import FormulaE.Types.Entrant exposing (Entrant)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias RaceInfo =
    { entrants : List Entrant
    , currentPrediction : Maybe Prediction
    , results : Maybe Prediction
    , scoredPredictions : List ScoredPrediction
    }


type alias Prediction =
    { pole : FormulaE.Types.Entrant.Id
    , fam : FormulaE.Types.Entrant.Id
    }


type alias ScoredColumn =
    { entrant : Entrant
    , score : Int
    }


type alias ScoredPrediction =
    { user : Types.User.Username {}
    , pole : ScoredColumn
    , fam : ScoredColumn
    , fl : ScoredColumn
    , hgc : ScoredColumn
    , first : ScoredColumn
    , second : ScoredColumn
    , third : ScoredColumn
    , fdnf : ScoredColumn
    , safetyCar : Bool
    , safetyCarPoints : Int
    , total : Int
    }


predictionDecoder : Decoder Prediction
predictionDecoder =
    Decode.succeed Prediction
        |> Pipeline.required "pole" Decode.int
        |> Pipeline.required "fam" Decode.int


decoder : Decoder RaceInfo
decoder =
    let
        scoredColumnDecoder : Decoder ScoredColumn
        scoredColumnDecoder =
            Decode.succeed ScoredColumn
                |> Pipeline.required "entrant" FormulaE.Types.Entrant.decoder
                |> Pipeline.required "score" Decode.int

        scoredPredictionDecoder : Decoder ScoredPrediction
        scoredPredictionDecoder =
            Decode.succeed ScoredPrediction
                |> Pipeline.custom Types.User.usernameDecoder
                |> Pipeline.required "pole" scoredColumnDecoder
                |> Pipeline.required "fam" scoredColumnDecoder
                |> Pipeline.required "fl" scoredColumnDecoder
                |> Pipeline.required "hgc" scoredColumnDecoder
                |> Pipeline.required "first" scoredColumnDecoder
                |> Pipeline.required "second" scoredColumnDecoder
                |> Pipeline.required "third" scoredColumnDecoder
                |> Pipeline.required "fdnf" scoredColumnDecoder
                |> Pipeline.required "safety-car" Decode.bool
                |> Pipeline.required "safety-car-points" Decode.int
                |> Pipeline.required "total" Decode.int
    in
    Decode.succeed RaceInfo
        |> Pipeline.required "entrants" (Decode.list FormulaE.Types.Entrant.decoder)
        |> Pipeline.optional "current-prediction" (Decode.map Just predictionDecoder) Nothing
        |> Pipeline.optional "results" (Decode.map Just predictionDecoder) Nothing
        |> Pipeline.optional "scored-predictions" (Decode.list scoredPredictionDecoder) []
