module FormulaE.Event exposing
    ( Event
    , Id
    , decoder
    )

import Iso8601
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Time


type alias Id =
    Int


type alias Event =
    { id : Id
    , round : Int
    , name : String
    , country : String
    , circuit : String
    , startTime : Time.Posix
    }


decoder : Decoder Event
decoder =
    Decode.succeed Event
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "round" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "country" Decode.string
        |> Pipeline.required "circuit" Decode.string
        |> Pipeline.required "startTime" Iso8601.decoder
