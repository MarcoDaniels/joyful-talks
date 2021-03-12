module Context exposing (..)

import Head
import Html exposing (Html)
import Pages
import Pages.PagePath exposing (PagePath)
import Shared.Types exposing (BasePage, Meta, PostPage, SEO)


type CookieMsg
    = CookieState CookieConsent
    | CookieAccept


type Msg
    = NoOp (Html ())
    | Cookie CookieMsg
    | MenuExpand Bool


type alias Element =
    Html Msg


type alias CookieConsent =
    { accept : Bool }


type alias Model =
    { cookieConsent : CookieConsent, menuExpand : Bool }


type alias Renderer =
    List Element


type alias PageData =
    { title : String, body : Element }


type Data
    = BaseData BasePage
    | PostData PostPage
    | UnknownData


type alias Content =
    { collection : String, data : Data }


type alias Metadata =
    { seo : SEO, feed : Maybe (List String), meta : Meta }


type alias MetadataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Metadata
    }


type alias StaticRequest =
    { view : Model -> Renderer -> PageData, head : List (Head.Tag Pages.PathKey) }
