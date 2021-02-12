module Layout exposing (view)

import Context exposing (PageContext)
import Data exposing (DataContext)
import Html exposing (Html)
import Html.Attributes exposing (href)


view : PageContext -> DataContext -> PageContext
view pageContext { frontmatter } =
    { title = pageContext.title
    , body =
        Html.div []
            [ Html.nav []
                (frontmatter.meta.navigation
                    |> List.map
                        (\navigation ->
                            Html.a [ href navigation.url ] [ Html.text navigation.text ]
                        )
                )
            , pageContext.body
            , Html.footer []
                (frontmatter.meta.footer
                    |> List.map
                        (\footer ->
                            Html.a [ href footer.url ] [ Html.text footer.text ]
                        )
                )
            ]
    }
