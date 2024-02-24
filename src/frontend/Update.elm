module Update exposing
    ( getEvents
    , getMe
    , getSeasonPredictions
    , getSessions
    , getTeams
    , initForRoute
    , update
    )

import Browser
import Browser.Navigation
import Dict exposing (Dict)
import Helpers.Dict
import Helpers.Http
import Helpers.List
import Http
import Json.Decode exposing (Decoder)
import Json.Encode as Encode
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Types.Entrant exposing (Entrant)
import Types.Event exposing (Event)
import Types.Prediction exposing (Prediction)
import Types.PredictionDict exposing (PredictionDict)
import Types.PredictionResults
import Types.Requests
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)
import Types.SessionPrediction exposing (SessionPrediction)
import Types.Team exposing (Team)
import Types.User exposing (User)
import Url


getMe : Model -> ( Model, Cmd Msg )
getMe model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult User -> Msg
                toMessage =
                    Msg.GetMeResponse

                decoder : Decoder User
                decoder =
                    Types.User.decoder
            in
            Http.get
                { url = "/api/auth/me"
                , expect = Http.expectJson toMessage decoder
                }
    in
    Return.withCmd command model


getTeams : Model -> ( Model, Cmd Msg )
getTeams model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List Team) -> Msg
                toMessage =
                    Msg.GetTeamsResponse

                decoder : Decoder (List Team)
                decoder =
                    Types.Team.decoder
                        |> Json.Decode.list

                url : String
                url =
                    let
                        seasonParam : String
                        seasonParam =
                            String.fromInt 2024
                    in
                    String.append "/api/formulaone/teams/" seasonParam
            in
            Http.get
                { url = url
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getTeamsStatus = Types.Requests.InFlight
    }
        |> Return.withCmd command


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

                url : String
                url =
                    let
                        eventParam : String
                        eventParam =
                            String.fromInt eventId
                    in
                    String.append "/api/formulaone/entrants/" eventParam
            in
            Http.get
                { url = url
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getEntrantsStatus = Dict.insert eventId Types.Requests.InFlight model.getEntrantsStatus
    }
        |> Return.withCmd command


getSeasonPredictions : Model -> ( Model, Cmd Msg )
getSeasonPredictions model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List SeasonPrediction) -> Msg
                toMessage =
                    Msg.GetSeasonPredictionsResponse

                decoder : Decoder (List SeasonPrediction)
                decoder =
                    Types.SeasonPrediction.decoder
                        |> Json.Decode.list

                url : String
                url =
                    let
                        seasonParam : String
                        seasonParam =
                            String.fromInt 2024
                    in
                    String.append "/api/formulaone/season-predictions/" seasonParam
            in
            Http.get
                { url = url
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getSeasonPredictionsStatus = Types.Requests.InFlight
    }
        |> Return.withCmd command


getSessionPredictions : Types.Event.Id -> Model -> ( Model, Cmd Msg )
getSessionPredictions eventId model =
    let
        command : Cmd Msg
        command =
            let
                toMessage : Types.Requests.HttpResult (List SessionPrediction) -> Msg
                toMessage =
                    Msg.GetPredictionsResponse eventId

                decoder : Decoder (List SessionPrediction)
                decoder =
                    Types.SessionPrediction.decoder
                        |> Json.Decode.list

                url : String
                url =
                    let
                        eventParam : String
                        eventParam =
                            String.fromInt eventId
                    in
                    String.append "/api/formulaone/session-predictions/" eventParam
            in
            Http.get
                { url = url
                , expect = Http.expectJson toMessage decoder
                }
    in
    { model
        | getSeasonPredictionsStatus = Types.Requests.InFlight
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
                |> Return.andThen (getSessionPredictions eventId)


logoutIfUauthorised : Http.Error -> Model -> Model
logoutIfUauthorised error model =
    case Helpers.Http.isUnauthorised error of
        False ->
            model

        True ->
            { model | user = Nothing }


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

        Msg.GetMeResponse result ->
            case result of
                Err error ->
                    logoutIfUauthorised error model
                        |> Return.noCmd

                Ok user ->
                    Return.noCmd { model | user = Just user }

        Msg.GetTeamsResponse result ->
            case result of
                Err _ ->
                    Return.noCmd { model | getTeamsStatus = Types.Requests.Failed }

                Ok teams ->
                    Return.noCmd
                        { model
                            | getTeamsStatus = Types.Requests.Succeeded
                            , teams = teams
                        }

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

        Msg.GetSeasonPredictionsResponse result ->
            case result of
                Err _ ->
                    Return.noCmd
                        { model
                            | getSeasonPredictionsStatus = Types.Requests.Failed
                        }

                Ok predictions ->
                    let
                        seasonPredictions : Dict Types.User.Id SeasonPrediction
                        seasonPredictions =
                            Helpers.Dict.fromListWith .user predictions
                    in
                    Return.noCmd
                        { model
                            | seasonPredictions = seasonPredictions
                            , getSeasonPredictionsStatus = Types.Requests.Succeeded
                        }

        Msg.MoveSeasonPrediction index upDown ->
            let
                currentPredictions : List Team
                currentPredictions =
                    Model.getSeasonInputPredictions model

                movingFun : Int -> List Team -> List Team
                movingFun =
                    case upDown of
                        Msg.Up ->
                            Helpers.List.moveItemUp

                        Msg.Down ->
                            Helpers.List.moveItemDown

                newPredictions : List Team
                newPredictions =
                    movingFun index currentPredictions
            in
            Return.noCmd
                { model | inputSeasonPredictions = Just newPredictions }

        Msg.SubmitSeasonPredictions ->
            let
                newModel : Model
                newModel =
                    { model | submitSeasonPredictionsStatus = Types.Requests.InFlight }

                command : Cmd Msg
                command =
                    let
                        toMessage : Types.Requests.HttpResult (List SeasonPrediction) -> Msg
                        toMessage =
                            Msg.SubmitSeasonPredictionsResponse

                        decoder : Decoder (List SeasonPrediction)
                        decoder =
                            Types.SeasonPrediction.decoder
                                |> Json.Decode.list

                        predictions : List Team
                        predictions =
                            Model.getSeasonInputPredictions model

                        encodePrediction : Int -> Team -> Encode.Value
                        encodePrediction index team =
                            Encode.object
                                [ ( "team", Encode.int team.id )
                                , ( "position", Encode.int (index + 1) )
                                ]

                        body : Encode.Value
                        body =
                            List.indexedMap encodePrediction predictions
                                |> Encode.list identity

                        url : String
                        url =
                            let
                                seasonParam : String
                                seasonParam =
                                    String.fromInt 2024
                            in
                            String.concat
                                [ "/api/formulaone/submit-season-predictions/"
                                , seasonParam
                                ]
                    in
                    Http.post
                        { url = url
                        , body = Http.jsonBody body
                        , expect = Http.expectJson toMessage decoder
                        }
            in
            Return.withModel newModel command

        Msg.SubmitSeasonPredictionsResponse result ->
            case result of
                Err _ ->
                    Return.noCmd
                        { model | submitSeasonPredictionsStatus = Types.Requests.Failed }

                Ok seasonPredictions ->
                    Return.noCmd
                        { model
                            | submitSeasonPredictionsStatus = Types.Requests.Succeeded
                            , inputSeasonPredictions = Nothing
                            , seasonPredictions = Helpers.Dict.fromListWith .user seasonPredictions
                        }

        Msg.GetPredictionsResponse eventId result ->
            case result of
                Err _ ->
                    Return.noCmd
                        { model | getPredictionsStatus = Dict.insert eventId Types.Requests.Failed model.getPredictionsStatus }

                Ok predictions ->
                    let
                        insert : SessionPrediction -> PredictionDict SessionPrediction -> PredictionDict SessionPrediction
                        insert sessionPrediction dict =
                            let
                                key : Types.PredictionResults.Key
                                key =
                                    case sessionPrediction.user == 0 of
                                        True ->
                                            Types.PredictionResults.SessionResult

                                        False ->
                                            Types.PredictionResults.UserPrediction sessionPrediction.user
                            in
                            Types.PredictionDict.insert key sessionPrediction.session sessionPrediction dict
                    in
                    { model | getPredictionsStatus = Dict.insert eventId Types.Requests.Succeeded model.getPredictionsStatus }
                        |> insertSessionPredictions predictions
                        |> Return.noCmd

        Msg.EditPredictions predictionContext sessionId edit ->
            let
                currentPredictions : List Prediction
                currentPredictions =
                    Model.getInputPredictions model predictionContext sessionId

                newPredictions : List Prediction
                newPredictions =
                    case edit of
                        Msg.MovePrediction index upDown ->
                            let
                                movingFun : Int -> List Prediction -> List Prediction
                                movingFun =
                                    case upDown of
                                        Msg.Up ->
                                            Helpers.List.moveItemUp

                                        Msg.Down ->
                                            Helpers.List.moveItemDown

                                rePosition : Int -> Prediction -> Prediction
                                rePosition zeroIndexed prediction =
                                    { prediction
                                        | position = zeroIndexed + 1

                                        -- This avoids the possibility that someone selects the fastest lap as say 10th
                                        -- and then moves that driver down.
                                        , fastestLap = prediction.fastestLap && zeroIndexed < 10
                                    }
                            in
                            movingFun index currentPredictions
                                |> List.indexedMap rePosition

                        Msg.FastestLapPrediction index ->
                            let
                                setFastestLap : Int -> Prediction -> Prediction
                                setFastestLap innerIndex prediction =
                                    { prediction | fastestLap = innerIndex == index }
                            in
                            List.indexedMap setFastestLap currentPredictions
            in
            Return.noCmd
                { model
                    | inputPredictions =
                        Types.PredictionDict.insert predictionContext sessionId newPredictions model.inputPredictions
                }

        Msg.SubmitPredictions predictionContext sessionId ->
            let
                newModel : Model
                newModel =
                    { model
                        | submitPredictionsStatus =
                            Types.PredictionDict.insert predictionContext sessionId Types.Requests.InFlight model.submitPredictionsStatus
                    }

                command : Cmd Msg
                command =
                    let
                        toMessage : Types.Requests.HttpResult (List Prediction) -> Msg
                        toMessage =
                            Msg.SubmitPredictionsResponse predictionContext sessionId

                        decoder : Decoder (List Prediction)
                        decoder =
                            Types.Prediction.decoder
                                |> Json.Decode.list

                        predictions : List Prediction
                        predictions =
                            Model.getInputPredictions model predictionContext sessionId

                        body : Encode.Value
                        body =
                            Encode.list Types.Prediction.encode predictions

                        url : String
                        url =
                            let
                                sessionParam : String
                                sessionParam =
                                    String.fromInt sessionId

                                submitSuffix : String
                                submitSuffix =
                                    case predictionContext of
                                        Types.PredictionResults.UserPrediction _ ->
                                            "predictions"

                                        Types.PredictionResults.SessionResult ->
                                            "results"
                            in
                            String.concat
                                [ "/api/formulaone/submit-"
                                , submitSuffix
                                , "/"
                                , sessionParam
                                ]
                    in
                    Http.post
                        { url = url
                        , body = Http.jsonBody body
                        , expect = Http.expectJson toMessage decoder
                        }
            in
            Return.withModel newModel command

        Msg.SubmitPredictionsResponse predictionContext sessionId result ->
            let
                insertStatus : Types.Requests.Status -> Model
                insertStatus status =
                    { model
                        | submitPredictionsStatus =
                            Types.PredictionDict.insert predictionContext sessionId status model.submitPredictionsStatus
                    }
            in
            case result of
                Err _ ->
                    insertStatus Types.Requests.Failed
                        |> Return.noCmd

                Ok predictions ->
                    let
                        user : { id : Types.User.Id, name : String }
                        user =
                            case predictionContext of
                                Types.PredictionResults.UserPrediction userId ->
                                    { id = userId
                                    , name =
                                        model.user
                                            |> Maybe.map .fullname
                                            |> Maybe.withDefault ""
                                    }

                                Types.PredictionResults.SessionResult ->
                                    { id = 0
                                    , name = "Results"
                                    }

                        sessionPrediction : SessionPrediction
                        sessionPrediction =
                            { session = sessionId
                            , user = user.id
                            , name = user.name
                            , predictions = predictions
                            }
                    in
                    insertStatus Types.Requests.Succeeded
                        |> removeInputSessionPredictions predictionContext sessionId
                        |> insertSessionPredictions [ sessionPrediction ]
                        |> Return.noCmd


removeInputSessionPredictions : Types.PredictionResults.Key -> Types.Session.Id -> Model -> Model
removeInputSessionPredictions key sessionId model =
    { model | inputPredictions = Types.PredictionDict.remove key sessionId model.inputPredictions }


insertSessionPredictions : List SessionPrediction -> Model -> Model
insertSessionPredictions predictions model =
    let
        insert : SessionPrediction -> PredictionDict SessionPrediction -> PredictionDict SessionPrediction
        insert sessionPrediction dict =
            let
                key : Types.PredictionResults.Key
                key =
                    case sessionPrediction.user == 0 of
                        True ->
                            Types.PredictionResults.SessionResult

                        False ->
                            Types.PredictionResults.UserPrediction sessionPrediction.user
            in
            Types.PredictionDict.insert key sessionPrediction.session sessionPrediction dict
    in
    { model | predictions = List.foldl insert model.predictions predictions }
