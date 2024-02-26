module Components.Button exposing (faceOrWorking)

import Components.WorkingIndicator
import Html exposing (Html)
import Types.Requests


faceOrWorking : Types.Requests.Status -> Html msg -> Html msg
faceOrWorking status face =
    case Types.Requests.isInFlight status of
        True ->
            Components.WorkingIndicator.view

        False ->
            face
