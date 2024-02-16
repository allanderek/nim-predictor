module Msg exposing (Msg (..))

import Browser
import Url exposing (Url)
import Types.Event exposing (Event)
import Types.Requests

type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
    | GetEventsResponse (Types.Requests.HttpResult (List Event))
