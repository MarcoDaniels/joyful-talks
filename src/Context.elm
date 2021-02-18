module Context exposing (..)

import Head
import Html exposing (Html)
import Pages
import Pages.PagePath exposing (PagePath)
import Shared.Types exposing (Base, Meta, Post)


type Msg
    = NoOp (Html ())
    | CookieState Model
    | CookieAccept


type alias Model =
    { cookieConsent : Bool }


type alias Renderer =
    List (Html Msg)


type alias PageData =
    { title : String, body : Html Msg }


type Data
    = BaseData Base
    | PostData Post
    | UnknownData


type alias Content =
    { collection : String, data : Data, meta : Meta }


type alias ContentContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Content
    }


type alias StaticRequest =
    { view : Model -> Renderer -> PageData, head : List (Head.Tag Pages.PathKey) }
