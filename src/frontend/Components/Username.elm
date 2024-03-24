module Components.Username exposing (view)

import Components.Symbols
import Helpers.Html
import Html exposing (Html)
import Html.Attributes
import Types.User


view : Types.User.Username a -> Html msg
view user =
    Html.span
        [ Html.Attributes.class "user-name" ]
        [ Html.text user.fullname
        , case user.id == 5 of
            True ->
                Components.Symbols.champion

            False ->
                Helpers.Html.nothing
        ]
