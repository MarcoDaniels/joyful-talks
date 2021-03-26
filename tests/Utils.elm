module Utils exposing (matchResult)


matchResult : Result a b -> Bool
matchResult result =
    case result of
        Ok _ ->
            True

        Err _ ->
            False
