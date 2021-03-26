module Element.Cookie exposing (..)

import Body.Type exposing (CookieBanner)
import Context exposing (CookieConsent, CookieMsg(..), Element, Msg(..))
import Element.Empty exposing (emptyNode)
import Element.Icon exposing (Icons(..), iconView)
import Element.Markdown exposing (markdownView)
import Html exposing (button, div, h2, text)
import Html.Attributes exposing (class, tabindex)
import Html.Events exposing (onClick)


cookieView : CookieConsent -> CookieBanner -> Element
cookieView consent { title, content } =
    if consent.accept then
        emptyNode

    else
        div [ tabindex 0, class "cookie" ]
            [ div [ class "container-s" ]
                [ h2 [ class "cookie-title" ] [ text title, iconView CookieIcon { size = "20", color = "#777777" } ]
                , markdownView content
                , div [ class "cookie-close" ]
                    [ button
                        [ class "cookie-close-button", onClick (Cookie <| CookieAccept) ]
                        [ text "Accept" ]
                    ]
                ]
            ]
