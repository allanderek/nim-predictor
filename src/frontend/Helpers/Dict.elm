module Helpers.Dict exposing
    ( fromListMap
    , fromListWith
    )

import Dict exposing (Dict)


fromListWith : (value -> comparable) -> List value -> Dict comparable value
fromListWith keyer =
    fromListMap keyer identity


fromListMap : (a -> comparable) -> (a -> value) -> List a -> Dict comparable value
fromListMap keyer valuer =
    let
        add : a -> Dict comparable value -> Dict comparable value
        add a =
            Dict.insert (keyer a) (valuer a)
    in
    List.foldl add Dict.empty
