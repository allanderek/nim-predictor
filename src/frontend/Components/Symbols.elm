module Components.Symbols exposing
    ( downArrow
    , sprint
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


sprint : Html msg
sprint =
    Html.text "🏃"
