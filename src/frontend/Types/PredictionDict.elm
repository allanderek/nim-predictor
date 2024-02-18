module Types.PredictionDict exposing
    ( Context(..)
    , PredictionDict
    , get
    , insert
    )

import Dict exposing (Dict)
import Types.Session
import Types.User


type Context
    = UserPrediction Types.User.Id
    | SessionResult


type alias Key =
    ( Types.User.Id, Types.Session.Id )


type alias PredictionDict a =
    Dict Key a


getKey : Context -> Types.Session.Id -> Key
getKey context sessionId =
    ( case context of
        UserPrediction userId ->
            userId

        SessionResult ->
            ""
    , sessionId
    )


get : Context -> Types.Session.Id -> PredictionDict a -> Maybe a
get context sessionId dict =
    Dict.get (getKey context sessionId) dict


insert : Context -> Types.Session.Id -> a -> PredictionDict a -> PredictionDict a
insert context sessionId value dict =
    Dict.insert (getKey context sessionId) value dict
