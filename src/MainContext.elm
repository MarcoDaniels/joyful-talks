module MainContext exposing (..)

import Html exposing (Html)


type Msg
    = NoOp (Html ())
    | Increment
    | Decrement
    | Reset


type alias Model =
    { count : Int }


type alias PageContext =
    { title : String, body : Html Msg }
