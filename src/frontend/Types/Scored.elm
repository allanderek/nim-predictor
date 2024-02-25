module Types.Scored exposing
    ( Scored
    , sort
    , sortHighestFirst
    , total
    , values
    )


type alias Scored a =
    { score : Int
    , value : a
    }


values : List (Scored a) -> List a
values scored =
    List.map .value scored


sort : List (Scored a) -> List (Scored a)
sort scored =
    List.sortBy .score scored


sortHighestFirst : List (Scored a) -> List (Scored a)
sortHighestFirst scored =
    sort scored
        |> List.reverse


total : List (Scored a) -> Int
total scored =
    List.map .score scored
        |> List.sum
