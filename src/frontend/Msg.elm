module Msg exposing (Msg(..))

import Browser
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Requests
import Types.Session exposing (Session)
import Url exposing (Url)


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | GetEventsResponse (Types.Requests.HttpResult (List Event))
    | GetSessionsResponse (Types.Requests.HttpResult (List Session))
    | GetEntrantsResponse Types.Event.Id (Types.Requests.HttpResult (List Entrant))
