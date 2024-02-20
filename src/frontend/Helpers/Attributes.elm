module Helpers.Attributes exposing (disabledOrOnClick)

import Html
import Html.Attributes as Attributes
import Html.Events


disabledOrOnClick : Bool -> msg -> Html.Attribute msg
disabledOrOnClick disabled message =
    case disabled of
        True ->
            Attributes.disabled True

        False ->
            Html.Events.onClick message
