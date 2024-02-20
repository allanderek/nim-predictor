module Model exposing
    ( Model
    , getInputPredictions
    , getSeasonInputPredictions
    , init
    )

import Browser.Navigation
import Dict exposing (Dict)
import Route exposing (Route)
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Prediction exposing (Prediction)
import Types.PredictionDict exposing (PredictionDict)
import Types.Requests
import Types.Session exposing (Session)
import Types.Team exposing (Team)
import Types.User exposing (User)


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    , user : Maybe User
    , getTeamsStatus : Types.Requests.Status
    , teams : List Team
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
    }


init : { navigationKey : Browser.Navigation.Key, route : Route } -> Model
init config =
    { navigationKey = config.navigationKey
    , route = config.route

    -- TODO: Obviously wrong
    , user =
        Just
            { id = "1"
            , username = "allanderek"
            , fullname = "Allan"
            , isAdmin = True
            }
    , getTeamsStatus = Types.Requests.Ready
    , teams = []
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
    }


getInputPredictions : Model -> Types.PredictionDict.Context -> Types.Session.Id -> List Prediction
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
    model.inputSeasonPredictions
        |> Maybe.withDefault model.teams
