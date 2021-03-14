module Element.Hero exposing (..)

import Body.Type exposing (HeroContent)
import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Html exposing (div, h1, text)
import Html.Attributes exposing (class)


heroView : HeroContent -> Element
heroView hero =
    div [ class "hero" ]
        [ assetView { src = hero.asset.path, alt = hero.asset.title } AssetHero
        , div [ class "hero-content container" ]
            [ h1 [ class "hero-content-text font-xl font-dancing" ] [ text hero.title ] ]
        ]
