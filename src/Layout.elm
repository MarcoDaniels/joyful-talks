module Layout exposing (view)

import Context exposing (PageContext)
import Data exposing (DataContext)
import Html exposing (Html)
import Html.Attributes exposing (href)
import Pages
import Pages.PagePath exposing (PagePath)


view : PageContext -> DataContext -> PageContext
view pageContext _ =
    { title = pageContext.title
    , body =
        Html.div []
            [ Html.nav []
                [ Html.a [ href (Pages.pages.index |> Pages.PagePath.toString) ] [ Html.text "joyful talks" ]
                , Html.a [ href (Pages.pages.about.index |> Pages.PagePath.toString) ] [ Html.text "about" ]
                , Html.a [ href (Pages.pages.about.people |> Pages.PagePath.toString) ] [ Html.text "people" ]
                , Html.a [ href (Pages.pages.about.allTheRest |> Pages.PagePath.toString) ] [ Html.text "and all the rest" ]
                ]
            , pageContext.body
            ]
    }
