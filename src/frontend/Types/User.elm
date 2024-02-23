module Types.User exposing
    ( Id
    , User
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Id =
    Int


type alias User =
    { id : Id
    , username : String
    , fullname : String
    , isAdmin : Bool
    }


decoder : Decoder User
decoder =
    Decode.succeed User
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "username" Decode.string
        |> Pipeline.required "fullname" Decode.string
        |> Pipeline.required "isAdmin" Decode.bool
