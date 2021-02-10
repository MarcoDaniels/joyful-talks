module Context exposing (..)

import Data.Types exposing (StandardPage)
import Html exposing (Html)
import Pages
import Pages.PagePath exposing (PagePath)


type alias DataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : StandardPage
    }


type alias Msg =
    ()


type alias PageContext =
    { title : String, body : Html Msg }
