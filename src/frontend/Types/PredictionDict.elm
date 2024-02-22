module Types.PredictionDict exposing
    ( PredictionDict
    , get
    , insert
    )

import Dict exposing (Dict)
import Types.PredictionResults exposing (PredictionResults)
import Types.Session


type alias PredictionDict a =
    Dict Types.Session.Id (PredictionResults a)


get : Types.PredictionResults.Key -> Types.Session.Id -> PredictionDict a -> Maybe a
get key sessionId dict =
    Dict.get sessionId dict
        |> Maybe.andThen (Types.PredictionResults.get key)


insert : Types.PredictionResults.Key -> Types.Session.Id -> a -> PredictionDict a -> PredictionDict a
insert key sessionId value dict =
    let
        update : Maybe (PredictionResults a) -> Maybe (PredictionResults a)
        update mPredResults =
            mPredResults
                |> Maybe.withDefault Types.PredictionResults.empty
                |> Types.PredictionResults.insert key value
                |> Just
    in
    Dict.update sessionId update dict
