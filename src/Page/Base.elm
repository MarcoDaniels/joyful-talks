module Page.Base exposing (baseDecoder, baseView)

import Body.Type exposing (BasePage, ContentValue(..))
import Context exposing (Element)
import Element.Asset exposing (AssetDefaultType(..), AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Hero exposing (heroView)
import Element.Markdown exposing (markdownView)
import Element.Row exposing (rowView)
import Html exposing (div)
import Html.Attributes exposing (class)
import OptimizedDecoder exposing (Decoder, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Shared.Decoder exposing (contentFieldValueDecoder)
import Shared.Ternary exposing (ternary)


baseDecoder : Decoder BasePage
baseDecoder =
    succeed BasePage
        |> required "title" string
        |> required "description" string
        |> required "url" string
        |> required "postsFeed" (maybe (list string))
        |> required "content" (maybe (list contentFieldValueDecoder))


baseView : BasePage -> Element
baseView base =
    div []
        (case base.content of
            Just cont ->
                List.concat
                    [ cont
                        |> List.map
                            (\content ->
                                case content.value of
                                    ContentValueMarkdown markdown ->
                                        div [ class "container-s" ] [ markdownView markdown ]

                                    ContentValueAsset image ->
                                        div [ class "container-s center" ]
                                            [ assetView { src = image.path, alt = image.title }
                                                (ternary (image.width > image.height)
                                                    (AssetDefault AssetDefaultLandscape)
                                                    (AssetDefault AssetDefaultPortrait)
                                                )
                                            ]

                                    ContentValueHero hero ->
                                        heroView hero

                                    ContentValueRow rowItems ->
                                        div [ class "container-s" ] [ rowView rowItems ]

                                    _ ->
                                        emptyNode
                            )
                    ]

            Nothing ->
                [ emptyNode ]
        )
