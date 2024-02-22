module Msg exposing
    ( Msg(..)
    , UpDown(..)
    )

import Browser
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.PredictionDict
import Types.Requests
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)
import Types.Team exposing (Team)
import Url exposing (Url)
import Types.PredictionResults


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | GetTeamsResponse (Types.Requests.HttpResult (List Team))
    | GetEventsResponse (Types.Requests.HttpResult (List Event))
    | GetSessionsResponse (Types.Requests.HttpResult (List Session))
    | GetEntrantsResponse Types.Event.Id (Types.Requests.HttpResult (List Entrant))
    | GetSeasonPredictionsResponse (Types.Requests.HttpResult (List SeasonPrediction))
    | MoveSeasonPrediction Int UpDown
    | SubmitSeasonPredictions
    | SubmitSeasonPredictionsResponse (Types.Requests.HttpResult (List SeasonPrediction))
    | GetPredictionsResponse Types.Event.Id (Types.Requests.HttpResult (List SessionPrediction))
    | MovePrediction Types.PredictionResults.Key Types.Session.Id Int UpDown
    | SubmitPredictions Types.PredictionResults.Key Types.Session.Id
    | SubmitPredictionsResponse Types.PredictionResults.Key Types.Session.Id (Types.Requests.HttpResult ())


type UpDown
    = Up
    | Down
