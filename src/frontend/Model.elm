module Model exposing
    ( Model
    , getInputPredictions
    , getPredictions
    , getSeasonInputPredictions
    , init
    )

import Browser.Navigation
import Dict exposing (Dict)
import FormulaE.Event
import FormulaE.Types.RaceInfo
import List.Extra
import Route exposing (Route)
import Time
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Leaderboard exposing (Leaderboard)
import Types.Prediction exposing (Prediction)
import Types.PredictionDict exposing (PredictionDict)
import Types.PredictionResults exposing (PredictionResults)
import Types.Requests
import Types.SeasonLeaderboard exposing (SeasonLeaderboard)
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)
import Types.Team exposing (Team)
import Types.User exposing (User)


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , now : Time.Posix
    , zone : Time.Zone
    , route : Route
    , user : Maybe User
    , loginUsername : String
    , loginPassword : String
    , loginStatus : Types.Requests.Status
    , logoutStatus : Types.Requests.Status
    , getTeamsStatus : Types.Requests.Status
    , teams : List Team
    , getSeasonPredictionsStatus : Types.Requests.Status
    , seasonPredictions : Dict Types.User.Id SeasonPrediction
    , inputSeasonPredictions : Maybe (List Team)
    , submitSeasonPredictionsStatus : Types.Requests.Status
    , getEventsStatus : Types.Requests.Status
    , events : List Event
    , getSessionsStatus : Types.Requests.Status
    , sessions : List Session
    , entrants : Dict Types.Session.Id (List Entrant)
    , getEntrantsStatus : Dict Types.Event.Id Types.Requests.Status
    , submitPredictionsStatus : PredictionDict Types.Requests.Status
    , inputPredictions : PredictionDict (List Prediction)
    , getPredictionsStatus : Dict Types.Event.Id Types.Requests.Status
    , predictions : PredictionDict SessionPrediction
    , getLeaderboardStatus : Types.Requests.Status
    , leaderboard : Maybe Leaderboard
    , getSeasonLeaderboardStatus : Types.Requests.Status
    , seasonLeaderboard : Maybe SeasonLeaderboard
    , eventTabs : Dict Types.Event.Id Types.Session.Id
    , getFormulaEEventsStatus : Types.Requests.Status
    , formulaEEvents : List FormulaE.Event.Event
    , getRaceInfoStatus : Dict FormulaE.Event.Id Types.Requests.Status
    , formulaERaceInfos : Dict FormulaE.Event.Id FormulaE.Types.RaceInfo.RaceInfo
    }


init : { navigationKey : Browser.Navigation.Key, now : Time.Posix, zone : Time.Zone, route : Route } -> Model
init config =
    { navigationKey = config.navigationKey
    , now = config.now
    , zone = config.zone
    , route = config.route
    , user = Nothing
    , loginUsername = ""
    , loginPassword = ""
    , loginStatus = Types.Requests.Ready
    , logoutStatus = Types.Requests.Ready
    , getTeamsStatus = Types.Requests.Ready
    , teams = []
    , getSeasonPredictionsStatus = Types.Requests.Ready
    , seasonPredictions = Dict.empty
    , inputSeasonPredictions = Nothing
    , submitSeasonPredictionsStatus = Types.Requests.Ready
    , events = []
    , getEventsStatus = Types.Requests.Ready
    , sessions = []
    , getSessionsStatus = Types.Requests.Ready
    , entrants = Dict.empty
    , getEntrantsStatus = Dict.empty
    , submitPredictionsStatus = Dict.empty
    , inputPredictions = Dict.empty
    , getPredictionsStatus = Dict.empty
    , predictions = Dict.empty
    , getLeaderboardStatus = Types.Requests.Ready
    , leaderboard = Nothing
    , getSeasonLeaderboardStatus = Types.Requests.Ready
    , seasonLeaderboard = Nothing
    , eventTabs = Dict.empty
    , getFormulaEEventsStatus = Types.Requests.Ready
    , formulaEEvents = []
    , getRaceInfoStatus = Dict.empty
    , formulaERaceInfos = Dict.empty
    }


getPredictions : Model -> Types.Session.Id -> Maybe (PredictionResults SessionPrediction)
getPredictions model sessionId =
    Dict.get sessionId model.predictions


getInputPredictions : Model -> Types.PredictionResults.Key -> Types.Session.Id -> List Prediction
getInputPredictions model context sessionId =
    let
        mInput : Maybe (List Prediction)
        mInput =
            Types.PredictionDict.get context sessionId model.inputPredictions
    in
    case mInput of
        Just predictions ->
            -- TODO: There is some extra things to do here, checking that each prediction is valid,
            -- that is, corresponds to an entrant in the session. Which might not be true if the entrants
            -- have changed.
            predictions

        Nothing ->
            case Types.PredictionDict.get context sessionId model.predictions of
                Just sessionPrediction ->
                    sessionPrediction.predictions

                Nothing ->
                    let
                        createPrediction : Int -> Entrant -> Prediction
                        createPrediction index entrant =
                            { entrant = entrant.id
                            , position = index + 1
                            , fastestLap = False
                            }
                    in
                    Dict.get sessionId model.entrants
                        |> Maybe.withDefault []
                        |> List.indexedMap createPrediction


getSeasonInputPredictions : Model -> List Team
getSeasonInputPredictions model =
    case model.inputSeasonPredictions of
        Just teams ->
            teams

        Nothing ->
            case model.user of
                Just user ->
                    case Dict.get user.id model.seasonPredictions of
                        Just seasonPredictions ->
                            let
                                getPosition : Team -> Int
                                getPosition team =
                                    List.Extra.findIndex (\pred -> pred.teamId == team.id) seasonPredictions.predictions
                                        |> Maybe.withDefault 100
                            in
                            List.sortBy getPosition model.teams

                        Nothing ->
                            model.teams

                Nothing ->
                    model.teams
