module Helpers.List exposing
    ( moveItemDown
    , moveItemUp
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
