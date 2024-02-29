module View exposing (view)

import Browser
import Components.InputPredictions
import Components.InputSeasonPredictions
import Components.Predictions
import Components.RequestButton
import Components.Symbols
import Components.WorkingIndicator
import Dict
import Helpers.Attributes
import Helpers.Html
import Helpers.Table
import Helpers.Time
import Html exposing (Html)
import Html.Attributes as Attributes
import Iso8601
import List.Extra
import Maybe.Extra
import Model exposing (Model)
import Msg exposing (Msg)
import Route exposing (Route)
import Time
import Types.Event exposing (Event)
import Types.PredictionResults
import Types.Requests
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)


routeHref : Route -> Html.Attribute msg
routeHref route =
    route
        |> Route.unparse
        |> Attributes.href


view : Model -> Browser.Document Msg
view model =
    let
        navBar : Html msg
        navBar =
            Html.nav
                []
                [ Html.ul
                    []
                    [ Html.li
                        []
                        [ Html.a
                            [ routeHref Route.Home ]
                            [ Html.text "Events" ]
                        ]
                    , Html.li
                        []
                        [ Html.a
                            [ routeHref Route.ProfilePage ]
                            [ model.user
                                |> Maybe.map .fullname
                                |> Maybe.withDefault "Login"
                                |> Html.text
                            ]
                        ]
                    ]
                ]

        main : List (Html Msg)
        main =
            case model.route of
                Route.Home ->
                    viewHome model

                Route.EventPage id ->
                    viewEventPage model id

                Route.ProfilePage ->
                    case model.user of
                        Nothing ->
                            let
                                disabled : Bool
                                disabled =
                                    Types.Requests.isInFlight model.loginStatus

                                fieldInput : String -> String -> (String -> Msg) -> Html Msg
                                fieldInput label current toMessage =
                                    Html.p
                                        []
                                        [ Html.label [] [ Html.text label ]
                                        , Html.input
                                            [ Attributes.value current
                                            , Helpers.Attributes.disabledOrOnInput disabled toMessage
                                            ]
                                            []
                                        ]
                            in
                            [ Html.form
                                [ Helpers.Attributes.disabledOrOnSubmit disabled Msg.Login ]
                                [ Html.fieldset
                                    []
                                    [ fieldInput "Username" model.loginUsername Msg.LoginInputUsername
                                    , fieldInput "Password" model.loginPassword Msg.LoginInputPassword
                                    ]
                                , Html.button
                                    [ Attributes.type_ "submit" 
                                    , Attributes.disabled disabled
                                    ]
                                    [ Html.text "Login"
                                        |> Components.RequestButton.faceOrWorking model.loginStatus
                                    ]
                                ]
                            ]

                        Just _ ->
                            [ Html.text "Sorry, I've not written a profile page yet."
                            , Components.RequestButton.view
                                { status = model.logoutStatus
                                , disabled = False
                                , message = Msg.Logout
                                , face = Html.text "Logout"
                                }
                            ]

                Route.NotFound ->
                    [ Html.text "Sorry, I do not recognise that page." ]
    in
    { title = "Pole prediction"
    , body = navBar :: main
    }


viewHome : Model -> List (Html Msg)
viewHome model =
    let
        getEventsStatus : Html Msg
        getEventsStatus =
            case model.getEventsStatus of
                Types.Requests.Ready ->
                    Helpers.Html.nothing

                Types.Requests.InFlight ->
                    Html.div
                        []
                        [ Components.WorkingIndicator.view
                        , Html.text "Getting the events."
                        ]

                Types.Requests.Succeeded ->
                    Helpers.Html.nothing

                Types.Requests.Failed ->
                    Html.text "The request to get the events failed."

        showEvent : Event -> Html Msg
        showEvent event =
            Html.tr
                []
                [ Helpers.Table.intCell event.round
                , Html.td []
                    [ Html.a
                        [ Route.EventPage event.id
                            |> routeHref
                        ]
                        [ Html.text event.name
                        , case event.isSprint of
                            False ->
                                Helpers.Html.nothing

                            True ->
                                Components.Symbols.sprint
                        ]
                    ]
                ]

        seasonStarting : Time.Posix
        seasonStarting =
            case Iso8601.toTime "2024-03-01T16:00:00Z" of
                Ok t ->
                    t

                Err _ ->
                    Helpers.Time.epoch

        seasonStarted : Bool
        seasonStarted =
            Helpers.Time.isBefore seasonStarting model.now
    in
    [ case seasonStarted || Maybe.Extra.isNothing model.user of
        False ->
            Components.InputSeasonPredictions.view model seasonStarting

        True ->
            Helpers.Html.nothing
    , getEventsStatus
    , Html.table
        [ Attributes.class "event-list" ]
        [ Html.tbody [] (List.map showEvent model.events) ]
    , case seasonStarted of
        False ->
            Helpers.Html.nothing

        True ->
            showSeasonPredictions model
    ]


showSeasonPredictions : Model -> Html msg
showSeasonPredictions model =
    let
        showUserPredictions : SeasonPrediction -> Html msg
        showUserPredictions seasonPrediction =
            let
                viewLine : Types.SeasonPrediction.Line -> Html msg
                viewLine line =
                    Html.tr
                        []
                        [ Helpers.Table.stringCell line.teamName ]
            in
            Html.div
                [ Attributes.class "user-season-predictions" ]
                [ Html.h4 [] [ Html.text seasonPrediction.name ]
                , Html.table
                    []
                    [ Html.tbody
                        []
                        (List.map viewLine seasonPrediction.predictions)
                    ]
                ]
    in
    Html.ul
        []
        (Dict.values model.seasonPredictions
            |> List.map showUserPredictions
        )


viewEventPage : Model -> Types.Event.Id -> List (Html Msg)
viewEventPage model eventId =
    case List.Extra.find (\event -> event.id == eventId) model.events of
        Nothing ->
            -- TODO: It should check if we are downloading the events.
            [ Html.text "Event not found" ]

        Just event ->
            let
                sessions : List (Html Msg)
                sessions =
                    List.filter (\session -> session.event == eventId) model.sessions
                        |> List.map (showSession model)
            in
            [ Html.h2
                []
                [ Html.text event.name ]
            , Html.node "main" [] sessions
            ]


showSession : Model -> Session -> Html Msg
showSession model session =
    let
        sessionStarted : Bool
        sessionStarted =
            Helpers.Time.isBefore session.startTime model.now

        input : Html Msg
        input =
            case model.user of
                Nothing ->
                    Helpers.Html.nothing

                Just user ->
                    case sessionStarted of
                        False ->
                            Components.InputPredictions.view model
                                { context = Types.PredictionResults.UserPrediction user.id
                                , session = session
                                }

                        True ->
                            case user.isAdmin of
                                False ->
                                    Helpers.Html.nothing

                                True ->
                                    Components.InputPredictions.view model
                                        { context = Types.PredictionResults.SessionResult
                                        , session = session
                                        }

        scores : Html Msg
        scores =
            case sessionStarted of
                False ->
                    Helpers.Html.nothing

                True ->
                    Components.Predictions.view model session
    in
    Html.section
        []
        [ Html.h2
            []
            [ Html.text session.name ]
        , Html.h3
            []
            [ Helpers.Time.showPosix model.zone session.startTime
                |> Html.text
            ]
        , input
        , scores
        ]
