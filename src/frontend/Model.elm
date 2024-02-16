module Model exposing (Model)

import Route exposing (Route)
import Browser.Navigation

type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    }
