module Layout exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (href)
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
    , body =
        Html.div []
            [ Html.nav []
                [ Html.a [ href (Pages.pages.index |> Pages.PagePath.toString) ] [ Html.text "joyful talks" ]
                , Html.a [ href (Pages.pages.about.index |> Pages.PagePath.toString) ] [ Html.text "about" ]
                , Html.a [ href (Pages.pages.about.people |> Pages.PagePath.toString) ] [ Html.text "people" ]
                , Html.a [ href (Pages.pages.about.allTheRest |> Pages.PagePath.toString) ] [ Html.text "and all the rest" ]
                ]
            , document.body
            ]
    }
