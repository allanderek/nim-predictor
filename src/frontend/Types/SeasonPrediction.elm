module Types.SeasonPrediction exposing
    ( SeasonPrediction
    , Line
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.Team
import Types.User


type alias SeasonPrediction =
    { user : Types.User.Id
    , name : String
    , predictions : List Line
    }


type alias Line =
    { teamId : Types.Team.Id
    , teamName : String
    }


decoder : Decoder SeasonPrediction
decoder =
    let
        prediction : Decoder Line
        prediction =
            Decode.succeed Line
                |> Pipeline.required "team_id" Decode.int
                |> Pipeline.required "team_name" Decode.string
    in
    Decode.succeed SeasonPrediction
        |> Pipeline.required "user" Decode.int
        |> Pipeline.required "name" Decode.string
        |> Pipeline.required "predictions" (Decode.list prediction)
