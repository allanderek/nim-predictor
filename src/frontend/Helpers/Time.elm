module Helpers.Time exposing
    ( encodePosix
    , epoch
    , isBefore
    , posixDecoder
    , showPosix
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Time


epoch : Time.Posix
epoch =
    Time.millisToPosix 0


isBefore : Time.Posix -> Time.Posix -> Bool
isBefore left right =
    Time.posixToMillis left < Time.posixToMillis right


posixDecoder : Decoder Time.Posix
posixDecoder =
    Decode.int |> Decode.map Time.millisToPosix


encodePosix : Time.Posix -> Encode.Value
encodePosix time =
    time |> Time.posixToMillis |> Encode.int


showPosix : Time.Zone -> Time.Posix -> String
showPosix zone p =
    [ Time.toMonth zone p |> showMonth
    , " "
    , Time.toDay zone p |> String.fromInt
    , " "
    , Time.toHour zone p |> String.fromInt |> String.pad 2 '0'
    , ":"
    , Time.toMinute zone p |> String.fromInt |> String.pad 2 '0'
    ]
        |> String.concat


showMonth : Time.Month -> String
showMonth month =
    case month of
        Time.Jan ->
            "Jan"

        Time.Feb ->
            "Feb"

        Time.Mar ->
            "Mar"

        Time.Apr ->
            "Apr"

        Time.May ->
            "May"

        Time.Jun ->
            "Jun"

        Time.Jul ->
            "Jul"

        Time.Aug ->
            "Aug"

        Time.Sep ->
            "Sep"

        Time.Oct ->
            "Oct"

        Time.Nov ->
            "Nov"

        Time.Dec ->
            "Dec"
