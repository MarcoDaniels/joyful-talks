module Layout exposing (view)

import Html exposing (Html, div)


view document page =
    { title = document.title
    , body =
        div [] (List.map (\x -> x) document.body)
    }
