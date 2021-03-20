module Element.Hero exposing (..)

import Body.Type exposing (HeroContent)
import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Markdown exposing (markdownView)
import Html exposing (div)
import Html.Attributes exposing (class)


heroView : HeroContent -> Element
heroView hero =
    div [ class "hero" ]
        [ assetView { src = hero.asset.path, alt = hero.asset.title } AssetHero
        , case hero.text of
            Just textContent ->
                div [ class "hero-content container" ]
                    [ markdownView textContent ]

            Nothing ->
                emptyNode
        ]
