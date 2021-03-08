module Element.Hero exposing (..)

import Context exposing (Element)
import Element.Image exposing (ImageType(..), imageView)
import Html exposing (div, h1, text)
import Html.Attributes exposing (class)
import Shared.Types exposing (HeroContent)


heroView : HeroContent -> Element
heroView hero =
    div [ class "hero" ]
        [ imageView { src = hero.image.path, alt = hero.image.title } ImageHero
        , div [ class "hero-content container" ]
            [ h1 [ class "hero-content-text font-xl font-dancing" ] [ text hero.title ] ]
        ]
