module View exposing (view)

import Browser
import Components.InputPredictions
import Components.InputSeasonPredictions
import Components.Predictions
import Components.RequestButton
import Components.Symbols
import Components.Username
import Components.WorkingIndicator
import Dict
import Formula1.Route
import FormulaE.Event
import FormulaE.Pages.Event
import FormulaE.Route
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
import Types.Leaderboard
import Types.PredictionResults
import Types.Requests
import Types.SeasonLeaderboard
import Types.SeasonPrediction exposing (SeasonPrediction)
import Types.Session exposing (Session)
import Types.User


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
            let
                link : Route -> String -> Html msg
                link route text =
                    Html.li
                        []
                        [ Html.a
                            [ routeHref route ]
                            [ Html.text text ]
                        ]
            in
            Html.nav
                []
                [ Html.ul
                    []
                    [ link Route.Home "Home"
                    , link (Route.Formula1 Formula1.Route.Leaderboard) "F1 Leaderboard"
                    -- , link (Route.FormulaE FormulaE.Route.Events) "FE Events"
                    , model.user
                        |> Maybe.map .fullname
                        |> Maybe.withDefault "Login"
                        |> link Route.ProfilePage
                    ]
                ]

        main : List (Html Msg)
        main =
            case model.route of
                Route.Home ->
                    viewHome model

                Route.Formula1 subRoute ->
                    case subRoute of
                        Formula1.Route.EventPage eventId mSessionId ->
                            viewEventPage model eventId mSessionId

                        Formula1.Route.Leaderboard ->
                            viewLeaderboard model

                        Formula1.Route.SeasonLeaderboard ->
                            viewSeasonLeaderboard model

                Route.FormulaE subRoute ->
                    case subRoute of
                        FormulaE.Route.Events ->
                            let
                                viewEventRow : FormulaE.Event.Event -> Html Msg
                                viewEventRow event =
                                    let
                                        cell : String -> Html Msg
                                        cell contents =
                                            Html.td
                                                []
                                                [ Html.a
                                                    [ FormulaE.Route.EventPage event.id 
                                                        |> Route.FormulaE
                                                        |> routeHref
                                                    ]
                                                    [ Html.text contents ]
                                                ]

                                        cells : List (Html Msg)
                                        cells =
                                            List.map cell
                                                [ String.fromInt event.round
                                                , event.name
                                                , event.country
                                                , event.circuit
                                                , Helpers.Time.showPosix model.zone event.startTime
                                                ]
                                    in
                                    Html.tr [] cells
                            in
                            [ Helpers.Table.simple
                                { head = [ Helpers.Table.headerRow [ "Round", "Name", "Country", "Circuit", "Date" ] ]
                                , body = List.map viewEventRow model.formulaEEvents
                                }
                            ]

                        FormulaE.Route.EventPage eventId ->
                            [ FormulaE.Pages.Event.view model eventId ]

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

                                submitDisabled : Bool
                                submitDisabled =
                                    disabled || String.isEmpty model.loginUsername || String.isEmpty model.loginPassword
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
                                    , Attributes.disabled submitDisabled
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


viewLeaderboard : Model -> List (Html Msg)
viewLeaderboard model =
    case model.leaderboard of
        Nothing ->
            case model.getLeaderboardStatus of
                Types.Requests.InFlight ->
                    [ Components.WorkingIndicator.view ]

                _ ->
                    -- A bit of a generic error, I could check if there *should* be a leaderboard.
                    [ Html.text "No leaderboard to show." ]

        Just leaderboard ->
            let
                includeSprint : Bool
                includeSprint =
                    List.any (\line -> line.sprintShootout /= 0) leaderboard

                ifIncludingSprint : Html msg -> Html msg
                ifIncludingSprint content =
                    case includeSprint of
                        False ->
                            Helpers.Html.nothing

                        True ->
                            content

                getMax : (Types.Leaderboard.Line -> Int) -> Int
                getMax getNum =
                    List.Extra.maximumBy getNum leaderboard
                        |> Maybe.map getNum
                        |> Maybe.withDefault 0

                maxSprintShootout : Int
                maxSprintShootout =
                    getMax .sprintShootout

                maxSprint : Int
                maxSprint =
                    getMax .sprint

                maxQualifying : Int
                maxQualifying =
                    getMax .qualifying

                maxRace : Int
                maxRace =
                    getMax .race

                showPossibleMax : Int -> Int -> Html msg
                showPossibleMax max value =
                    case value == max && max > 0 of
                        True ->
                            value
                                |> Helpers.Html.int
                                |> Helpers.Html.wrapped Html.u
                                |> Helpers.Table.cell

                        False ->
                            Helpers.Table.intCell value

                showLine : Types.Leaderboard.Line -> Html msg
                showLine line =
                    Html.tr
                        []
                        [ Components.Username.view line
                            |> Helpers.Table.cell
                        , showPossibleMax maxSprintShootout line.sprintShootout
                            |> ifIncludingSprint
                        , showPossibleMax maxSprint line.sprint
                            |> ifIncludingSprint
                        , showPossibleMax maxQualifying line.qualifying
                        , showPossibleMax maxRace line.race
                        , line.total
                            |> Helpers.Html.int
                            |> Helpers.Html.wrapped Html.b
                            |> Helpers.Table.cell
                        ]
            in
            [ Html.table
                []
                [ Html.thead
                    []
                    [ Html.tr
                        []
                        [ Helpers.Table.stringHeaderCell "Predictor"
                        , Helpers.Table.stringHeaderCell "Sprint-Shootout"
                            |> ifIncludingSprint
                        , Helpers.Table.stringHeaderCell "Sprint"
                            |> ifIncludingSprint
                        , Helpers.Table.stringHeaderCell "Qualifying"
                        , Helpers.Table.stringHeaderCell "Race"
                        , Helpers.Table.stringHeaderCell "Total"
                        ]
                    ]
                , Html.tbody
                    []
                    (List.map showLine leaderboard)
                ]
            ]


viewSeasonLeaderboard : Model -> List (Html Msg)
viewSeasonLeaderboard model =
    case model.seasonLeaderboard of
        Nothing ->
            case model.getSeasonLeaderboardStatus of
                Types.Requests.InFlight ->
                    [ Components.WorkingIndicator.view ]

                _ ->
                    -- A bit of a generic error, I could check if there *should* be a leaderboard.
                    [ Html.text "No leaderboard to show." ]

        Just leaderboard ->
            let
                makeGroup : ( Types.SeasonLeaderboard.Line, List Types.SeasonLeaderboard.Line ) -> { id : Types.User.Id, fullname : String, total : Int, lines : List Types.SeasonLeaderboard.Line }
                makeGroup ( principal, lines ) =
                    { id = principal.id
                    , fullname = principal.fullname
                    , total = List.sum (List.map .difference lines)
                    , lines = principal :: lines
                    }

                groups : List { id : Types.User.Id, fullname : String, total : Int, lines : List Types.SeasonLeaderboard.Line }
                groups =
                    List.Extra.gatherWith (\left right -> left.id == right.id) leaderboard
                        |> List.map makeGroup
                        |> List.sortBy .total

                showGroup : { id : Types.User.Id, fullname : String, total : Int, lines : List Types.SeasonLeaderboard.Line } -> Html msg
                showGroup group =
                    let
                        showLine : Types.SeasonLeaderboard.Line -> Html msg
                        showLine line =
                            Html.tr
                                []
                                [ Helpers.Table.intCell line.position
                                , Helpers.Table.stringCell line.team
                                , Helpers.Table.intCell line.difference
                                ]
                    in
                    Html.details
                        []
                        [ Html.summary
                            [ Attributes.class "season-leaderboard-group-title" ]
                            [ Components.Username.view group
                            , Helpers.Html.int group.total
                                |> Helpers.Html.wrapped Html.b
                            ]
                        , Helpers.Table.simple
                            { head = [ Helpers.Table.headerRow [ "Position", "Team", "Difference" ] ]
                            , body = List.map showLine group.lines
                            }
                        ]
            in
            List.map showGroup groups


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
                        [ Formula1.Route.EventPage event.id Nothing
                            |> Route.Formula1
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


viewEventPage : Model -> Types.Event.Id -> Maybe Types.Session.Id -> List (Html Msg)
viewEventPage model eventId mSessionId =
    case List.Extra.find (\event -> event.id == eventId) model.events of
        Nothing ->
            -- TODO: It should check if we are downloading the events.
            [ Html.text "Event not found" ]

        Just event ->
            let
                sessions : List Session
                sessions =
                    List.filter (\session -> session.event == eventId) model.sessions

                viewTabHeading : Session -> Html Msg
                viewTabHeading session =
                    let
                        isSelectedTab : Bool
                        isSelectedTab =
                            case selectedTab of
                                Nothing ->
                                    False

                                Just selected ->
                                    selected.id == session.id
                    in
                    Html.button
                        [ Attributes.class "tab-heading"

                        -- , Route.EventPage event.id (Just session.id)
                        --     |> routeHref
                        , Msg.OpenEventTab event.id session.id
                            |> Helpers.Attributes.disabledOrOnClick isSelectedTab
                        ]
                        [ Html.text session.name ]

                tabs : Html Msg
                tabs =
                    Html.div
                        [ Attributes.class "tab-selector" ]
                        (List.map viewTabHeading sessions)

                selectedTab : Maybe Session
                selectedTab =
                    mSessionId
                        |> Maybe.andThen (\sessionId -> List.Extra.find (\session -> session.id == sessionId) sessions)
                        |> Maybe.Extra.orElse (List.head sessions)

                content : Html Msg
                content =
                    case selectedTab of
                        Nothing ->
                            Html.text "There are no sessions in this event"

                        Just session ->
                            showSession model session
            in
            [ Html.h2
                []
                [ Html.text event.name ]
            , Html.node "main"
                []
                [ tabs
                , content
                ]
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
