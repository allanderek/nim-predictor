module Types.User exposing
    ( User
    , Id
    )

type alias Id =
    String

type alias User =
    { id : Id
    , username : String
    , fullname : String
    , isAdmin: Bool
    }
