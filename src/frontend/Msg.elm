module Msg exposing
    ( EditPredictions(..)
    , FormulaEMsg(..)
    , Msg(..)
    , UpDown(..)
    )

import Browser
import FormulaE.Event
import FormulaE.Types.RaceInfo
import Time
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Leaderboard exposing (Leaderboard)
import Types.Prediction exposing (Prediction)
import Types.PredictionResults
import Types.Requests
import Types.SeasonLeaderboard exposing (SeasonLeaderboard)
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)
import Types.Team exposing (Team)
import Types.User exposing (User)
import Url exposing (Url)


type Msg
    = Tick Time.Posix
    | UrlRequest Browser.UrlRequest
    | UrlChange Url
    | LoginInputUsername String
    | LoginInputPassword String
    | Login
    | LoginResponse (Types.Requests.HttpResult User)
    | Logout
    | LogoutResponse (Types.Requests.HttpResult ())
    | GetMeResponse (Types.Requests.HttpResult User)
    | GetTeamsResponse (Types.Requests.HttpResult (List Team))
    | GetEventsResponse (Types.Requests.HttpResult (List Event))
    | GetSessionsResponse (Types.Requests.HttpResult (List Session))
    | GetEntrantsResponse Types.Event.Id (Types.Requests.HttpResult (List Entrant))
    | GetSeasonPredictionsResponse (Types.Requests.HttpResult (List SeasonPrediction))
    | MoveSeasonPrediction Int UpDown
    | SubmitSeasonPredictions
    | SubmitSeasonPredictionsResponse (Types.Requests.HttpResult (List SeasonPrediction))
    | GetPredictionsResponse Types.Event.Id (Types.Requests.HttpResult (List SessionPrediction))
    | EditPredictions Types.PredictionResults.Key Types.Session.Id EditPredictions
    | SubmitPredictions Types.PredictionResults.Key Types.Session.Id
    | SubmitPredictionsResponse Types.PredictionResults.Key Types.Session.Id (Types.Requests.HttpResult (List Prediction))
    | GetLeaderboardResponse (Types.Requests.HttpResult Leaderboard)
    | GetSeasonLeaderboardResponse (Types.Requests.HttpResult SeasonLeaderboard)
    | FormulaEMsg FormulaEMsg
    | OpenEventTab Types.Event.Id Types.Session.Id


type EditPredictions
    = MovePrediction Int UpDown
    | FastestLapPrediction Int


type UpDown
    = Up
    | Down


type FormulaEMsg
    = GetFormulaEEventsResponse (Types.Requests.HttpResult (List FormulaE.Event.Event))
    | GetFormulaERaceInfoResponse FormulaE.Event.Id (Types.Requests.HttpResult FormulaE.Types.RaceInfo.RaceInfo)
