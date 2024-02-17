module Types.Entrant exposing
    ( Entrant
    , Id
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Session


type alias Id =
    Int


type alias Entrant =
    { id : Id
    , session : Types.Session.Id
    , number : Int
    , driver : String
    , team : String
    }


decoder : Decoder Entrant
decoder =
    Decode.succeed Entrant
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "session" Decode.int
        |> Pipeline.required "number" Decode.int
        |> Pipeline.required "driver" Decode.string
        |> Pipeline.required "team" Decode.string
