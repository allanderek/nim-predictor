module Types.Leaderboard exposing
    ( Leaderboard
    , Line
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline
import Types.User


type alias Leaderboard =
    List Line


type alias Line =
    { id : Types.User.Id
    , fullname : String
    , score : Int
    }


decoder : Decoder Leaderboard
decoder =
    let
        lineDecoder : Decoder Line
        lineDecoder =
            Decode.succeed Line
                |> Pipeline.required "user" Decode.int
                |> Pipeline.required "fullname" Decode.string
                |> Pipeline.required "score" Decode.int
    in
    Decode.list lineDecoder
