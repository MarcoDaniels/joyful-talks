module Context exposing (..)

import Html exposing (Html)


type alias Msg =
    ()


type alias PageContext =
    { title : String, body : Html Msg }
