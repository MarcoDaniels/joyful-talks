module Context exposing (..)

import Data.Types exposing (Data)
import Html exposing (Html)
import Pages
import Pages.PagePath exposing (PagePath)


type alias DataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Data
    }


type alias Msg =
    ()


type alias PageContext =
    { title : String, body : Html Msg }
