module Update exposing (update)

import Browser
import Browser.Navigation
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Msg.UrlChange url ->
            { model | route = Route.parse url }
                |> Return.noCmd

        Msg.UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    Url.toString url
                        |> Browser.Navigation.pushUrl model.navigationKey
                        |> Return.cmdWith model

                Browser.External url ->
                    Browser.Navigation.load url
                        |> Return.cmdWith model
