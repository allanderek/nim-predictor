module Types.Session exposing
    ( Id
    , Session
    , decoder
    )

import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Time
import Types.Event


type alias Id =
    Int


type alias Session =
    { id : Id
    , event : Types.Event.Id
    , name : String
    , fastestLap : Bool
    , startTime : Time.Posix
    , halfPoints : Bool
    }


decoder : Decoder Session
decoder =
    Decode.succeed Session
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "event" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "fastest_lap" Decode.bool
        |> Pipeline.required "start_time" Iso8601.decoder
        |> Pipeline.required "half_points" Decode.bool
