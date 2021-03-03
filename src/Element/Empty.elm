module Element.Empty exposing (emptyNode)

import Context exposing (Msg)
import Html exposing (Html, text)


emptyNode : Html Msg
emptyNode =
    text ""
