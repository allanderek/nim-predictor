module Helpers.Http exposing (isUnauthorised)

import Http


isUnauthorised : Http.Error -> Bool
isUnauthorised error =
    case error of
        Http.BadStatus 401 ->
            True

        Http.BadStatus _ ->
            False

        Http.BadUrl _ ->
            False

        Http.Timeout ->
            False

        Http.NetworkError ->
            False

        Http.BadBody _ ->
            False
