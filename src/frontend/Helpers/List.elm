module Helpers.List exposing
    ( moveItemDown
    , moveItemUp
    , findBy
    )

import List.Extra


moveItemDown : Int -> List a -> List a
moveItemDown index list =
    let
        ( above, rest ) =
            List.Extra.splitAt index list
    in
    case rest of
        x :: y :: others ->
            above ++ (y :: x :: others)

        _ ->
            list


moveItemUp : Int -> List a -> List a
moveItemUp index items =
    moveItemDown (index - 1) items


findBy : (a -> b) -> b -> List a -> Maybe a
findBy toId id items =
    List.Extra.find (\item -> toId item == id) items
