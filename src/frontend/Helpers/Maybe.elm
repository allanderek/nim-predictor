module Helpers.Maybe exposing (withMaybeDefault)

import Maybe.Extra


withMaybeDefault : Maybe a -> Maybe a -> Maybe a
withMaybeDefault left right =
    -- This is intended to be used in a pipe very similar to 'Maybe.withDefault'.
    -- mPriority
    --     |> Helpers.Maybe.withMaybeDefault mSecondary
    case Maybe.Extra.isNothing right of
        True ->
            left

        False ->
            right
