module Components.Symbols exposing
    ( champion
    , downArrow
    , gear
    , sprint
    , stopWatch
    , upArrow
    )

import Html exposing (Html)


champion : Html msg
champion =
    Html.text "🏆"


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
