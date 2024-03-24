module Types.User exposing
    ( Id
    , User
    , Username
    , decoder
    , usernameDecoder
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


type alias Id =
    Int


type alias Username a =
    { a
        | id : Id
        , fullname : String
    }


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

usernameDecoder : Decoder (Username {})
usernameDecoder =
    Decode.succeed (\id fullname -> { id = id, fullname = fullname })
        |> Pipeline.required "id" Decode.int
        |> Pipeline.required "fullname" Decode.string
