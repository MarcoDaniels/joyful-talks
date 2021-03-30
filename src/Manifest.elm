module Manifest exposing (manifest)

import Color
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Settings exposing (settings)


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.lifestyle ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = settings.description
    , iarcRatingId = Nothing
    , name = settings.title
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just settings.title
    , sourceIcon = images.iconPng
    , icons = []
    }
