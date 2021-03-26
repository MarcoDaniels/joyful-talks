module Layout exposing (layoutView)

import Body.Type exposing (BodyData(..), Settings)
import Context exposing (Content, Element, Model)
import Element.Cookie exposing (cookieView)
import Element.Footer exposing (footerView)
import Element.Header exposing (headerView)
import Html exposing (div)
import Html.Attributes exposing (id)
import Pages exposing (PathKey)
import Pages.PagePath exposing (PagePath)


layoutView : PagePath PathKey -> Model -> Settings -> Element -> Element
layoutView path model settings bodyContent =
    div [ id "app" ]
        [ headerView path settings.navigation model.menuExpand
        , bodyContent
        , footerView settings.footer
        , cookieView model.cookieConsent settings.cookie
        ]
