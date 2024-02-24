module Components.Symbols exposing
    ( downArrow
    , stopWatch
    , upArrow
    )

import Html exposing (Html)


upArrow : Html msg
upArrow =
    Html.text "↑"


downArrow : Html msg
downArrow =
    Html.text "↓"


stopWatch : Html msg
stopWatch =
    Html.text "⏱"
