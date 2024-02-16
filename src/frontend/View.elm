module View exposing (view)

import Browser
import Html
import Model exposing (Model)
import Msg exposing (Msg)


view : Model -> Browser.Document Msg
view _ =
    { title = "Pole prediction"
    , body =
        [ Html.text "I am a view model." ]
    }
