module Shared.Date exposing (decodeDate, formatDate)

import OptimizedDecoder exposing (Decoder, andThen, int, succeed)
import Time exposing (Month(..), Posix, toDay, toMonth, toYear, utc)


decodeDate : Decoder Posix
decodeDate =
    int |> andThen (\ms -> succeed <| Time.millisToPosix ms)


formatDate : Posix -> String
formatDate time =
    String.fromInt (toYear utc time)
        ++ " "
        ++ (case toMonth utc time of
                Jan ->
                    "january"

                Feb ->
                    "february"

                Mar ->
                    "march"

                Apr ->
                    "april"

                May ->
                    "may"

                Jun ->
                    "june"

                Jul ->
                    "july"

                Aug ->
                    "august"

                Sep ->
                    "september"

                Oct ->
                    "october"

                Nov ->
                    "november"

                Dec ->
                    "december"
           )
        ++ " "
        ++ String.fromInt (toDay utc time)
