module Element.Cookie exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import MainContext exposing (Msg(..))


cookieView : Bool -> Html Msg
cookieView accept =
    if accept then
        Html.div [] []

    else
        Html.div [ Html.Attributes.class "center" ]
            [ Html.button [ Html.Events.onClick CookieAccept ] [ Html.text "Accept" ] ]
