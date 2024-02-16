module Model exposing (Model)

import Route exposing (Route)
import Browser.Navigation
import Types.Requests
import Types.Event exposing (Event)

type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    , getEventsStatus : Types.Requests.Status
    , events : List Event
    }
