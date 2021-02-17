module Layout exposing (view)

import Context exposing (ContentContext, Model, Msg(..), PageData)
import Element.Cookie exposing (cookieView)
import Html exposing (Html)
import Html.Attributes exposing (href)


view : PageData -> ContentContext -> Model -> PageData
view pageData { frontmatter } model =
    { title = pageData.title
    , body =
        Html.div []
            [ Html.nav []
                (frontmatter.meta.navigation
                    |> List.map
                        (\navigation ->
                            Html.a [ href navigation.url ] [ Html.text navigation.text ]
                        )
                )
            , pageData.body
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
