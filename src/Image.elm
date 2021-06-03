module Image exposing (..)


imageAPI : String -> Maybe Int -> String
imageAPI src maybeSrcSet =
    case maybeSrcSet of
        Just srcSet ->
            "/image/api" ++ src ++ "?w=" ++ String.fromInt srcSet ++ "&o=1&q=60&m=fitToWidth " ++ String.fromInt srcSet ++ "w"

        Nothing ->
            "/image/api" ++ src ++ "?w=900&o=1&q=60&m=fitToWidth"
