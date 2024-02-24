module Types.PredictionDict exposing
    ( PredictionDict
    , get
    , insert
    , remove
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


remove : Types.PredictionResults.Key -> Types.Session.Id -> PredictionDict a -> PredictionDict a
remove key sessionId dict =
    let
        update : Maybe (PredictionResults a) -> Maybe (PredictionResults a)
        update mPredResults =
            Maybe.map (Types.PredictionResults.remove key) mPredResults
                |> Maybe.andThen Types.PredictionResults.nothingIfEmpty
    in
    Dict.update sessionId update dict
