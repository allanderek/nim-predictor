module Model exposing
    ( Model
    , getInputPredictions
    , init
    )

import Browser.Navigation
import Dict exposing (Dict)
import Route exposing (Route)
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Prediction exposing (Prediction)
import Types.Requests
import Types.Session exposing (Session)


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    , getEventsStatus : Types.Requests.Status
    , events : List Event
    , getSessionsStatus : Types.Requests.Status
    , sessions : List Session
    , entrants : Dict Types.Session.Id (List Entrant)
    , getEntrantsStatus : Dict Types.Event.Id Types.Requests.Status
    , submitPredictionsStatus : Dict Types.Session.Id Types.Requests.Status
    , inputPredictions : Dict Types.Session.Id (List Prediction)
    }


init : { navigationKey : Browser.Navigation.Key, route : Route } -> Model
init config =
    { navigationKey = config.navigationKey
    , route = config.route
    , events = []
    , getEventsStatus = Types.Requests.Ready
    , sessions = []
    , getSessionsStatus = Types.Requests.Ready
    , entrants = Dict.empty
    , getEntrantsStatus = Dict.empty
    , submitPredictionsStatus = Dict.empty
    , inputPredictions = Dict.empty
    }


getInputPredictions : Model -> Types.Session.Id -> List Prediction
getInputPredictions model sessionId =
    let
        mInput : Maybe (List Prediction)
        mInput =
            Dict.get sessionId model.inputPredictions
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
