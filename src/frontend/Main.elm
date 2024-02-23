module Main exposing (main)

import Browser
import Browser.Navigation
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
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
            Model.init
                { navigationKey = key
                , route = Route.parse url
                }
    in
    Update.initForRoute initialModel
        |> Return.andThen Update.getTeams
        |> Return.andThen Update.getEvents
        |> Return.andThen Update.getSessions
        |> Return.andThen Update.getSeasonPredictions
        |> Return.andThen Update.getMe
