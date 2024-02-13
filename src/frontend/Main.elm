module Main exposing (main)

import Route
import Return
import Browser
import Browser.Navigation
import Html
import Url exposing (Url)
import Html
import Route exposing (Route)


type alias ProgramFlags =
    ()


type alias Model =
    { navigationKey : Browser.Navigation.Key
    , route : Route
    }



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
init _ url key =
    let
        initialModel : Model
        initialModel =
            { navigationKey = key
            , route = Route.parse url
            }
    in
    Return.noCmd initialModel


view : Model -> Browser.Document Msg
view _ =
    { title = "Pole prediction"
    , body = 
        [ Html.text "I am a view model." ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        UrlChange url ->
            { model | route = Route.parse url }
                |> Return.noCmd

        UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    Browser.Navigation.pushUrl model.navigationKey (Url.toString url)
                        |> Return.cmdWith model

                Browser.External url ->
                    Browser.Navigation.load url
                        |> Return.cmdWith model
