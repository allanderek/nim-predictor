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
    , startTime : String
    , halfPoints : Bool
    }


decoder : Decoder Session
decoder =
    Decode.succeed Session
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "event" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "start_time" Decode.string
        |> Pipeline.required "half_points" Decode.bool
