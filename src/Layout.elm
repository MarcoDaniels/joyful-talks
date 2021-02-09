module Layout exposing (view)

import Html exposing (Html)
import Page
import Pages
import Pages.PagePath exposing (PagePath)


view :
    { title : String, body : Html msg }
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Page.Page
        }
    -> { title : String, body : Html msg }
view document _ =
    { title = document.title
    , body = document.body
    }
