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


type alias Layout =
    { title : String, body : Element }


type alias Metadata =
    { seo : SEO, feed : Maybe (List String), meta : Meta }


type alias MetadataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Metadata
    }


type alias StaticRequest =
    { view : Model -> Renderer -> Layout, head : List (Head.Tag Pages.PathKey) }


type alias MetadataGenerate =
    List { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String }


type alias StaticRequestGenerate =
    List (Result String { path : List String, content : String })
