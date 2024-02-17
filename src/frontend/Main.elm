module Main exposing (main)

import Browser
import Browser.Navigation
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Types.Requests
import Update
import Url exposing (Url)
import View


type alias ProgramFlags =
    ()


main : Program ProgramFlags Model Msg
main =
    let
        subscriptions : Model -> Sub Msg
        subscriptions =
            always Sub.none
    in
    Browser.application
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = subscriptions
        , onUrlRequest = Msg.UrlRequest
        , onUrlChange = Msg.UrlChange
        }


init : ProgramFlags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialModel : Model
        initialModel =
            { navigationKey = key
            , route = Route.parse url
            , events = []
            , getEventsStatus = Types.Requests.Ready
            , sessions = []
            , getSessionsStatus = Types.Requests.Ready
            }
    in
    Update.getEvents initialModel
        |> Return.andThen Update.getSessions
