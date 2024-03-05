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
    , sprintShootout : Int
    , sprint : Int
    , qualifying : Int
    , race : Int
    , total : Int
    }


decoder : Decoder Leaderboard
decoder =
    let
        lineDecoder : Decoder Line
        lineDecoder =
            Decode.succeed Line
                |> Pipeline.required "user" Decode.int
                |> Pipeline.required "fullname" Decode.string
                |> Pipeline.required "sprint-shootout" Decode.int
                |> Pipeline.required "sprint" Decode.int
                |> Pipeline.required "qualifying" Decode.int
                |> Pipeline.required "race" Decode.int
                |> Pipeline.required "total" Decode.int
    in
    Decode.list lineDecoder
