module Layout exposing (view)

import Context exposing (ContentContext, Model, Msg(..), PageData)
import Element.Cookie exposing (cookieView)
import Element.Footer exposing (footerView)
import Element.Header exposing (headerView)
import Html exposing (Html, article)
import Html.Attributes exposing (class, id)


view : PageData -> ContentContext -> Model -> PageData
view pageData context model =
    { title = pageData.title
    , body =
        Html.div [ class "contentWrapper" ]
            [ headerView context model.menuExpand
            , article [ id "content", class "container" ] [ pageData.body ]
            , cookieView model.cookieConsent context.frontmatter.meta.cookie
            , footerView context.frontmatter.meta.footer
            ]
    }
