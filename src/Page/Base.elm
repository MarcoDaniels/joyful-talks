module Page.Base exposing (baseDecoder, baseView)

import Context exposing (Element)
import Element.Empty exposing (emptyNode)
import Element.Hero exposing (heroView)
import Element.Markdown exposing (markdownView)
import Element.Row exposing (rowView)
import Html exposing (div)
import Html.Attributes exposing (class)
import OptimizedDecoder exposing (Decoder, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Shared.Decoder exposing (contentFieldValueDecoder)
import Shared.Types exposing (BasePage, ContentValue(..), Feed, Field, HeroContent)


baseDecoder : Decoder BasePage
baseDecoder =
    succeed BasePage
        |> required "title" string
        |> required "description" string
        |> required "postsFeed" (maybe (list string))
        |> required "content" (list contentFieldValueDecoder)


baseView : BasePage -> Element
baseView base =
    div []
        (List.concat
            [ base.content
                |> List.map
                    (\content ->
                        case content.value of
                            ContentValueMarkdown markdown ->
                                div [ class "container" ] [ markdownView markdown ]

                            ContentValueAsset asset ->
                                -- assetView { src = asset.path, alt = asset.title } AssetDefault
                                emptyNode

                            ContentValueHero hero ->
                                heroView hero

                            ContentValueRow rowItems ->
                                div [ class "container" ] [ rowView rowItems ]

                            _ ->
                                emptyNode
                    )
            ]
        )
