module Layout exposing (view)

import Context exposing (ContentContext, Model, Msg(..), PageData)
import Element.Cookie exposing (cookieView)
import Element.Footer exposing (footerView)
import Html exposing (Html)
import Html.Attributes exposing (href)


view : PageData -> ContentContext -> Model -> PageData
view pageData { frontmatter } model =
    { title = pageData.title
    , body =
        Html.div []
            [ Html.nav []
                (frontmatter.meta.navigation.menu
                    |> List.map
                        (\navigation ->
                            Html.a [ href navigation.url ] [ Html.text navigation.text ]
                        )
                )
            , pageData.body
            , cookieView model.cookieConsent frontmatter.meta.cookie
            , footerView frontmatter.meta.footer
            ]
    }
