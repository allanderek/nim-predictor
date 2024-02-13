module Main exposing (main)

import Browser
import Browser.Navigation
import Html
import Url exposing (Url)
import Html


type alias ProgramFlags =
    ()


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    }


type Route
    = Home


type Msg
    = UrlRequest Browser.UrlRequest
    | UrlChange Url


main : Program ProgramFlags Model Msg
main =
    let
        subscriptions : Model -> Sub Msg
        subscriptions =
            always Sub.none
    in
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequest
        , onUrlChange = UrlChange
        }


init : ProgramFlags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ _ key =
    let
        initialModel : Model
        initialModel =
            { navigationKey = key
            , route = Home
            }
    in
    ( initialModel
    , Cmd.none
    )


view : Model -> Browser.Document Msg
view _ =
    { title = "Pole prediction"
    , body = 
        [ Html.text "I am a view model." ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )
