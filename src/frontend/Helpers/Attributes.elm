module Helpers.Attributes exposing
    ( disabledOrOnClick
    , disabledOrOnInput
    , disabledOrOnSubmit
    )

import Html
import Html.Attributes as Attributes
import Html.Events


disabledOr : Bool -> Html.Attribute msg -> Html.Attribute msg
disabledOr disabled attribute =
    case disabled of
        True ->
            Attributes.disabled True

        False ->
            attribute


disabledOrOnClick : Bool -> msg -> Html.Attribute msg
disabledOrOnClick disabled message =
    Html.Events.onClick message
        |> disabledOr disabled


disabledOrOnInput : Bool -> (String -> msg) -> Html.Attribute msg
disabledOrOnInput disabled toMessage =
    Html.Events.onInput toMessage
        |> disabledOr disabled


disabledOrOnSubmit : Bool -> msg -> Html.Attribute msg
disabledOrOnSubmit disabled message =
    Html.Events.onSubmit message
        |> disabledOr disabled
