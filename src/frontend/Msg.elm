module Msg exposing (Msg (..))

import Browser
import Url exposing (Url)

type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url
