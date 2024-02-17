module Model exposing (Model)

import Browser.Navigation
import Dict exposing (Dict)
import Route exposing (Route)
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
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
    }
