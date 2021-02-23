module Element.Cookie exposing (..)

import Context exposing (CookieConsent, Msg(..))
import Html exposing (Html, button, div, h4, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Shared.Types exposing (CookieInformation)


cookieView : CookieConsent -> CookieInformation -> Html Msg
cookieView cookie { title, content } =
    if cookie.accept then
        div [] []

    else
        div [ class "cookie-overlay" ]
            [ div [ class "cookie-overlay-wrapper" ]
                [ h4 [] [ text title ]
                , p [] [ text content ]
                , div []
                    [ button
                        [ class "cookie-overlay-wrapper-close", onClick CookieAccept ]
                        [ text "Accept" ]
                    ]
                ]
            ]
