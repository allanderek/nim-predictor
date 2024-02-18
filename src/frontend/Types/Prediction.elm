module Types.Prediction exposing
    ( Prediction
    , decoder
    , encode
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Pipeline as Pipeline
import Types.Entrant

type alias Prediction =
    { entrant : Types.Entrant.Id
    , position : Int
    , fastestLap : Bool
    }

decoder : Decoder Prediction
decoder =
    Decode.succeed Prediction
        |> Pipeline.required "entrant" Decode.int
        |> Pipeline.required "position" Decode.int
        |> Pipeline.required "fastestLap" Decode.bool

encode : Prediction -> Encode.Value
encode prediction =
    Encode.object
        [ ( "position", Encode.int prediction.position )
        , ( "entrant", Encode.int prediction.entrant )
        , ( "fastest_lap", Encode.bool prediction.fastestLap )
        ]
