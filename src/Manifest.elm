module Manifest exposing (manifest)

import Color
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.lifestyle ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "joyful talks about people and all the rest"
    , iarcRatingId = Nothing
    , name = "joyful talks"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "joyful talks"
    , sourceIcon = images.iconPng
    , icons = []
    }
