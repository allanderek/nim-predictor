module Update exposing
    ( getEvents
    , getSessions
    , update
    )

import Browser
import Browser.Navigation
import Http
import Json.Decode exposing (Decoder)
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Types.Event exposing (Event)
import Types.Requests
import Types.Session exposing (Session)
import Url


getEvents : Model -> ( Model, Cmd Msg )
getEvents model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List Event) -> Msg
                toMessage =
                    Msg.GetEventsResponse

                decoder : Decoder (List Event)
                decoder =
                    Types.Event.decoder
                        |> Json.Decode.list
            in
            Http.get
                { url = "/api/formulaone/events"
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getEventsStatus = Types.Requests.InFlight
    }
        |> Return.withCmd command


getSessions : Model -> ( Model, Cmd Msg )
getSessions model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List Session) -> Msg
                toMessage =
                    Msg.GetSessionsResponse

                decoder : Decoder (List Session)
                decoder =
                    Types.Session.decoder
                        |> Json.Decode.list
            in
            Http.get
                { url = "/api/formulaone/sessions"
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getSessionsStatus = Types.Requests.InFlight
    }
        |> Return.withCmd command


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

        Msg.GetEventsResponse result ->
            case result of
                Err _ ->
                    Return.noCmd { model | getEventsStatus = Types.Requests.Failed }

                Ok events ->
                    Return.noCmd
                        { model
                            | getEventsStatus = Types.Requests.Succeeded
                            , events = events
                        }

        Msg.GetSessionsResponse result ->
            case result of
                Err _ ->
                    Return.noCmd { model | getSessionsStatus = Types.Requests.Failed }

                Ok sessions ->
                    Return.noCmd
                        { model
                            | getSessionsStatus = Types.Requests.Succeeded
                            , sessions = sessions
                        }
