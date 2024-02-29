module Components.RequestButton exposing
    ( faceOrWorking
    , view
    )

import Components.WorkingIndicator
import Helpers.Attributes
import Html exposing (Html)
import Types.Requests


type alias Config msg =
    { status : Types.Requests.Status
    , disabled : Bool
    , message : msg
    , face : Html msg
    }


faceOrWorking : Types.Requests.Status -> Html msg -> Html msg
faceOrWorking status face =
    case Types.Requests.isInFlight status of
        True ->
            Components.WorkingIndicator.view

        False ->
            face


view : Config msg -> Html msg
view config =
    let
        statusDisabled : Bool
        statusDisabled =
            case config.status of
                Types.Requests.InFlight ->
                    True

                Types.Requests.Ready ->
                    False

                Types.Requests.Succeeded ->
                    False

                Types.Requests.Failed ->
                    -- Arguably true, it should be that you are forced to change something to make this runnable again.
                    -- But that's risky, lots of possibility for a user to get stuck in a place where the button is
                    -- disabled but they cannot enable it.
                    False

        face : Html msg
        face =
            faceOrWorking config.status config.face
    in
    Html.button
        [ Helpers.Attributes.disabledOrOnClick (config.disabled || statusDisabled) config.message ]
        [ face ]
