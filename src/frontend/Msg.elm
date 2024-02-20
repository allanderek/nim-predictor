module Msg exposing
    ( Msg(..)
    , UpDown(..)
    )

import Browser
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Team exposing (Team)
import Types.PredictionDict
import Types.Requests
import Types.Session exposing (Session)
import Url exposing (Url)


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | GetTeamsResponse (Types.Requests.HttpResult (List Team))
    | GetEventsResponse (Types.Requests.HttpResult (List Event))
    | GetSessionsResponse (Types.Requests.HttpResult (List Session))
    | GetEntrantsResponse Types.Event.Id (Types.Requests.HttpResult (List Entrant))
    | MoveSeasonPrediction Int UpDown 
    | SubmitSeasonPredictions
    | SubmitSeasonPredictionsResponse (Types.Requests.HttpResult () )
    | MovePrediction Types.PredictionDict.Context Types.Session.Id Int UpDown
    | SubmitPredictions Types.PredictionDict.Context Types.Session.Id
    | SubmitPredictionsResponse Types.PredictionDict.Context Types.Session.Id (Types.Requests.HttpResult ())


type UpDown
    = Up
    | Down
