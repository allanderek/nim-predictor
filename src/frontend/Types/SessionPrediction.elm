module Types.SessionPrediction exposing
    ( SessionPrediction
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Prediction exposing (Prediction)
import Types.Session
import Types.User


type alias SessionPrediction =
    { session : Types.Session.Id
    , user : Types.User.Id
    , name : String
    , predictions : List Prediction
    }


decoder : Decoder SessionPrediction
decoder =
    Decode.succeed SessionPrediction
        |> Pipeline.required "session" Decode.int
        |> Pipeline.required "user" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "predictions" (Decode.list Types.Prediction.decoder)
