module Main exposing (main)

import Browser
import Browser.Navigation
import Dict
import Json.Decode exposing (Decoder)
import Model exposing (Model)
import Msg exposing (Msg)
import Return
import Route
import Time
import TimeZone
import Update
import Url exposing (Url)
import View


type alias ProgramFlags =
    Json.Decode.Value


main : Program ProgramFlags Model Msg
main =
    let
        minuteOfMilliseconds : Float
        minuteOfMilliseconds =
            1000 * 60

        subscriptions : Model -> Sub Msg
        subscriptions =
            Time.every minuteOfMilliseconds Msg.Tick
                |> always
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
init programFlags url key =
    let
        decodeFlag : a -> String -> Decoder a -> a
        decodeFlag default fieldName fieldDecoder =
            Json.Decode.decodeValue (Json.Decode.field fieldName fieldDecoder) programFlags
                |> Result.withDefault default

        now : Time.Posix
        now =
            let
                epoch : Time.Posix
                epoch =
                    -- I could probably have a better default than this, say the start of the year or something
                    Time.millisToPosix 0
            in
            Json.Decode.int
                |> Json.Decode.map Time.millisToPosix
                |> decodeFlag epoch "now"

        zone : Time.Zone
        zone =
            -- TODO: We can use a task to get the time zone I believe.
            case Dict.get "Europe/London" TimeZone.zones of
                Just getZone ->
                    getZone ()

                Nothing ->
                    Time.utc

        initialModel : Model
        initialModel =
            Model.init
                { navigationKey = key
                , route = Route.parse url
                , now = now
                , zone = zone
                }
    in
    Update.initForRoute initialModel
        |> Return.andThen Update.getTeams
        |> Return.andThen Update.getEvents
        |> Return.andThen Update.getSessions
        |> Return.andThen Update.getSeasonPredictions
        |> Return.andThen Update.getMe
