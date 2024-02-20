module Types.Team exposing
    ( Id
    , Team
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline

type alias Id =
    Int

type alias Team =
    { id : Id
    , season : String
    , fullname : String
    , shortname : String
    , color : String
    }

decoder : Decoder Team
decoder =
    Decode.succeed Team
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "season" Decode.string
        |> Pipeline.required "fullname" Decode.string
        |> Pipeline.required "shortname" Decode.string
        |> Pipeline.required "color" Decode.string

