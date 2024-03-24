module FormulaE.Types.Entrant exposing
    ( Entrant
    , Id
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Id =
    Int


type alias Entrant =
    { id : Id
    , name : String
    , team : String
    }


decoder : Decoder Entrant
decoder =
    Decode.succeed Entrant
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "driver" Decode.string
        |> Pipeline.required "team" Decode.string
