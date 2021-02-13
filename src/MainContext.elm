module MainContext exposing (..)

import Html exposing (Html)


type Msg
    = NoOp (Html ())
    | CookieState Model
    | CookieAccept


type alias Model =
    { cookieConsent : Bool }


type alias PageContext =
    { title : String, body : Html Msg }
