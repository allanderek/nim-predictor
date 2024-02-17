module Model exposing (Model)

import Browser.Navigation
import Route exposing (Route)
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
    }
