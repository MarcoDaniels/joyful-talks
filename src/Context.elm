module Context exposing (..)

import Html exposing (Html)
import Page.Decoder as Decoder
import Pages
import Pages.PagePath exposing (PagePath)


type alias DataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Decoder.Page
    }


type alias Msg =
    ()


type alias PageContext =
    { title : String, body : Html Msg }
