module Types.Requests exposing
    ( HttpResult
    , Status(..)
    , isInFlight
    )

import Http


type Status
    = Ready
    | InFlight
    | Succeeded
    | Failed


type alias HttpResult a =
    Result Http.Error a


isInFlight : Status -> Bool
isInFlight status =
    case status of
        InFlight ->
            True

        Ready ->
            False

        Succeeded ->
            False

        Failed ->
            False
