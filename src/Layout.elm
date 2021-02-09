module Layout exposing (view)

import Html exposing (Html)
import Metadata exposing (PageMetadata)
import Pages
import Pages.PagePath exposing (PagePath)


view :
    { title : String, body : Html msg }
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : PageMetadata
        }
    -> { title : String, body : Html msg }
view document _ =
    { title = document.title
    , body = document.body
    }
