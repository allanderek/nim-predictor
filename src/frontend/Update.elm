module Update exposing
    ( getEvents
    , getSessions
    , initForRoute
    , update
    )

import Browser
import Browser.Navigation
import Dict exposing (Dict)
import Http
import Json.Decode exposing (Decoder)
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Types.Entrant exposing (Entrant)
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


getEntrants : Types.Event.Id -> Model -> ( Model, Cmd Msg )
getEntrants eventId model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List Entrant) -> Msg
                toMessage =
                    Msg.GetEntrantsResponse eventId

                decoder : Decoder (List Entrant)
                decoder =
                    Types.Entrant.decoder
                        |> Json.Decode.list
            in
            Http.get
                { url = String.append "/api/formulaone/entrants/" (String.fromInt eventId)
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getEntrantsStatus = Dict.insert eventId Types.Requests.InFlight model.getEntrantsStatus
    }
        |> Return.withCmd command


initForRoute : Model -> ( Model, Cmd Msg )
initForRoute model =
    case model.route of
        Route.Home ->
            Return.noCmd model

        Route.NotFound ->
            Return.noCmd model

        Route.EventPage eventId ->
            getEntrants eventId model


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Msg.UrlChange url ->
            initForRoute { model | route = Route.parse url }

        Msg.UrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    Url.toString url
                        |> Browser.Navigation.pushUrl model.navigationKey
                        |> Return.withModel model

                Browser.External url ->
                    Browser.Navigation.load url
                        |> Return.withModel model

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

        Msg.GetEntrantsResponse eventId result ->
            case result of
                Err _ ->
                    Return.noCmd
                        { model
                            | getEntrantsStatus =
                                Dict.insert eventId Types.Requests.Failed model.getEntrantsStatus
                        }

                Ok entrants ->
                    let
                        addEntrant : Entrant -> Dict Types.Session.Id (List Entrant) -> Dict Types.Session.Id (List Entrant)
                        addEntrant entrant dict =
                            let
                                currentEntrants : List Entrant
                                currentEntrants =
                                    Dict.get entrant.session dict
                                        |> Maybe.withDefault []

                                newEntrants : List Entrant
                                newEntrants =
                                    entrant :: currentEntrants
                            in
                            Dict.insert entrant.session newEntrants dict

                        newEntrantsDict : Dict Types.Session.Id (List Entrant)
                        newEntrantsDict =
                            List.foldl addEntrant Dict.empty entrants
                    in
                    Return.noCmd
                        { model
                            | entrants = Dict.union newEntrantsDict model.entrants
                            , getEntrantsStatus = Dict.remove eventId model.getEntrantsStatus
                        }
