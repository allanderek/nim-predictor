module Types.PredictionResults exposing
    ( Key(..)
    , PredictionResults
    , empty
    , get
    , insert
    )

import Dict exposing (Dict)
import Types.User


type Key
    = UserPrediction Types.User.Id
    | SessionResult


type alias PredictionResults a =
    { result : Maybe a
    , predictions : Dict Types.User.Id a
    }


empty : PredictionResults a
empty =
    { result = Nothing
    , predictions = Dict.empty
    }


get : Key -> PredictionResults a -> Maybe a
get key predResults =
    case key of
        SessionResult ->
            predResults.result

        UserPrediction userId ->
            Dict.get userId predResults.predictions


insert : Key -> a -> PredictionResults a -> PredictionResults a
insert key value predResults =
    case key of
        SessionResult ->
            { predResults | result = Just value }

        UserPrediction userId ->
            { predResults | predictions = Dict.insert userId value predResults.predictions }
