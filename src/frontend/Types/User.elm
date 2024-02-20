module Types.User exposing
    ( User
    , Id
    )

type alias Id =
    Int

type alias User =
    { id : Id
    , username : String
    , fullname : String
    , isAdmin: Bool
    }
