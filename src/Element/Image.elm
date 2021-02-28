module Element.Image exposing (imageView)

import Context exposing (Msg)
import Html exposing (Html, img)
import Html.Attributes exposing (src)



-- TODO: include srcset for images


imageView : String -> Html Msg
imageView path =
    img [ src (path ++ "?w=300&o=1") ] []
