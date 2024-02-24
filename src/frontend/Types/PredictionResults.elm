module Types.PredictionResults exposing
    ( Key(..)
    , PredictionResults
    , empty
    , get
    , insert
    , nothingIfEmpty
    , remove
    )

import Dict exposing (Dict)
import Maybe.Extra
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


isEmpty : PredictionResults a -> Bool
isEmpty predResults =
    Maybe.Extra.isNothing predResults.result && Dict.isEmpty predResults.predictions


nothingIfEmpty : PredictionResults a -> Maybe (PredictionResults a)
nothingIfEmpty predResults =
    case isEmpty predResults of
        True ->
            Nothing

        False ->
            Just predResults


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


remove : Key -> PredictionResults a -> PredictionResults a
remove key predResults =
    case key of
        SessionResult ->
            { predResults | result = Nothing }

        UserPrediction userId ->
            { predResults | predictions = Dict.remove userId predResults.predictions }
