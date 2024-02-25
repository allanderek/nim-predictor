module Types.Event exposing
    ( Event
    , Id
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Id =
    Int


type alias Event =
    { id : Id
    , round : Int
    , name : String
    , season : String
    , isSprint : Bool
    }


decoder : Decoder Event
decoder =
    Decode.succeed Event
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "round" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "season" Decode.string
        |> Pipeline.required "isSprint" Decode.bool
