module Types.Session exposing
    ( Id
    , Session
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Event


type alias Id =
    Int


type alias Session =
    { id : Id
    , event : Types.Event.Id
    , name : String
    , fastestLap : Bool
    , startTime : String
    , halfPoints : Bool
    }


decoder : Decoder Session
decoder =
    let
        nameHasFastestLap : String -> Bool
        nameHasFastestLap name =
            case name of
                "qualifying" ->
                    False

                "sprint-shootout" ->
                    False

                "sprint" ->
                    True

                "race" ->
                    True

                _ ->
                    False

        fastestLap : Decoder Bool
        fastestLap =
            Decode.string
                |> Decode.map nameHasFastestLap
    in
    Decode.succeed Session
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "event" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "name" fastestLap
        |> Pipeline.required "start_time" Decode.string
        |> Pipeline.required "half_points" Decode.bool
