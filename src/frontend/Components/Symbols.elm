module Components.Symbols exposing
    ( downArrow
    , gear
    , sprint
    , stopWatch
    , upArrow
    )

import Html exposing (Html)


gear : Html msg
gear =
    Html.text "⚙"


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
