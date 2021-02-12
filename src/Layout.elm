module Layout exposing (view)

import Content exposing (ContentContext)
import MainContext exposing (Model, Msg(..), PageContext)
import Element.Counter exposing (counterView)
import Html exposing (Html)
import Html.Attributes exposing (href)


view : PageContext -> ContentContext -> Model -> PageContext
view pageContext { frontmatter } model =
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
            , counterView model.count
            , Html.footer []
                (frontmatter.meta.footer
                    |> List.map
                        (\footer ->
                            Html.a [ href footer.url ] [ Html.text footer.text ]
                        )
                )
            ]
    }
