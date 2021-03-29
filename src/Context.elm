module Context exposing (..)

import Body.Type exposing (BodyData, Settings)
import Head
import Html exposing (Html)
import Metadata.Type exposing (PageMetadata)
import Pages
import Pages.PagePath exposing (PagePath)


type CookieMsg
    = CookieState CookieConsent
    | CookieAccept


type alias PageChange =
    { path : PagePath Pages.PathKey
    , query : Maybe String
    , fragment : Maybe String
    , metadata : PageMetadata
    }


type Msg
    = NoOp (Html ())
    | Cookie CookieMsg
    | MenuExpand Bool
    | OnPageChange PageChange
    | OnPreviewUpdate String


type alias Element =
    Html Msg


type alias CookieConsent =
    { accept : Bool }


type alias Model =
    { cookieConsent : CookieConsent, menuExpand : Bool }


type alias Content =
    { collection : String, data : BodyData, settings : Settings }


type alias View =
    { title : String, body : Element }


type alias MetadataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : PageMetadata
    }


type alias StaticRequest =
    { view : Model -> Content -> View, head : List (Head.Tag Pages.PathKey) }


type alias MetadataGenerate =
    List { path : PagePath Pages.PathKey, frontmatter : PageMetadata, body : String }


type alias StaticRequestGenerate =
    List (Result String { path : List String, content : String })
