module Types.SeasonLeaderboard exposing
    ( Line
    , SeasonLeaderboard
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.User


type alias SeasonLeaderboard =
    List Line


type alias Line =
    { id : Types.User.Id
    , fullname : String
    , position : Int
    , team : String
    , difference : Int
    }


decoder : Decoder SeasonLeaderboard
decoder =
    let
        lineDecoder : Decoder Line
        lineDecoder =
            Decode.succeed Line
                |> Pipeline.required "user_id" Decode.int
                |> Pipeline.required "fullname" Decode.string
                |> Pipeline.required "position" Decode.int
                |> Pipeline.required "team" Decode.string
                |> Pipeline.required "difference" Decode.int
    in
    Decode.list lineDecoder
