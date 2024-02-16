module Types.Requests exposing
    ( HttpResult
    , Status(..)
    )

import Http


type Status
    = Ready
    | InFlight
    | Succeeded
    | Failed


type alias HttpResult a =
    Result Http.Error a
