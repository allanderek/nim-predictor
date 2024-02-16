module Types.Event exposing
    ( Event
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline

type alias Event =
    { round : Int
    , name : String
    , season : String
    }

decoder : Decoder Event 
decoder =
    Decode.succeed Event
        |> Pipeline.required "round" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "season" Decode.string
