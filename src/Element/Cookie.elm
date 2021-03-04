module Element.Cookie exposing (..)

import Context exposing (CookieConsent, CookieMsg(..), Msg(..))
import Element.Empty exposing (emptyNode)
import Element.Icon exposing (Icons(..), iconView)
import Html exposing (Html, button, div, h4, p, text)
import Html.Attributes exposing (class, tabindex)
import Html.Events exposing (onClick)
import Shared.Types exposing (CookieBanner)


cookieView : CookieConsent -> CookieBanner -> Html Msg
cookieView consent { title, content } =
    if consent.accept then
        emptyNode

    else
        div [ tabindex 0, class "cookie" ]
            [ div [ class "cookie-wrapper container" ]
                [ h4 [ class "cookie-wrapper-title" ] [ text title, iconView CookieIcon { size = "20", color = "#777777" } ]
                , p [ class "cookie-wrapper-text" ] [ text content ]
                , div [ class "cookie-wrapper-close" ]
                    [ button
                        [ class "cookie-wrapper-close-button", onClick (Cookie <| CookieAccept) ]
                        [ text "Accept" ]
                    ]
                ]
            ]
