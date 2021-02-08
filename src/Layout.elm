module Layout exposing (view)

import Html exposing (Html, div)
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath exposing (PagePath)


view :
    { title : String, body : List (Html msg) }
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    -> { title : String, body : Html msg }
view document _ =
    { title = document.title
    , body =
        div [] (List.map (\x -> x) document.body)
    }
