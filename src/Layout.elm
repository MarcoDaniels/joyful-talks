module Layout exposing (view)

import Content exposing (ContentContext)
import Element.Cookie exposing (cookieView)
import Html exposing (Html)
import Html.Attributes exposing (href)
import MainContext exposing (Model, Msg(..), PageContext)


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
            , cookieView model.cookieConsent
            , Html.footer []
                (frontmatter.meta.footer
                    |> List.map
                        (\footer ->
                            Html.a [ href footer.url ] [ Html.text footer.text ]
                        )
                )
            ]
    }
