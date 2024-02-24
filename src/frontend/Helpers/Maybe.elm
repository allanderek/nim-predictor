module Helpers.Maybe exposing (ifNothing)


ifNothing : Maybe a -> Maybe a -> Maybe a
ifNothing mA mB =
    case mA of
        Just _ ->
            mA

        Nothing ->
            mB
