module Page.Base exposing (baseDecoder, baseView)

import Context exposing (Element, PageData)
import Element.Empty exposing (emptyNode)
import Element.Hero exposing (heroView)
import Element.Row exposing (rowView)
import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown exposing (markdownRender)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (assetDecoder, fieldDecoder, rowContentDecoder)
import Shared.Types exposing (Base, BaseContent, BaseContentValue(..), Feed, Field, HeroContent)


baseDecoder : Decoder Base
baseDecoder =
    succeed Base
        |> required "title" string
        |> required "description" string
        |> required "postsFeed" (maybe (list string))
        |> required "content"
            (list
                (succeed BaseContent
                    |> required "field" fieldDecoder
                    |> custom
                        (field "field" fieldDecoder
                            |> andThen
                                (\field ->
                                    case ( field.fieldType, field.label ) of
                                        ( "markdown", _ ) ->
                                            succeed BaseContentValueMarkdown
                                                |> required "value" string

                                        ( "asset", _ ) ->
                                            succeed BaseContentValueAsset
                                                |> required "value" assetDecoder

                                        ( "set", "Hero" ) ->
                                            succeed BaseContentValueHero
                                                |> required "value"
                                                    (succeed HeroContent
                                                        |> required "title" string
                                                        |> required "image" assetDecoder
                                                    )

                                        ( "repeater", "Row" ) ->
                                            succeed BaseContentValueRow
                                                |> required "value" (list rowContentDecoder)

                                        _ ->
                                            succeed BaseContentValueUnknown
                                )
                        )
                )
            )


baseView : Base -> Element
baseView base =
    div []
        (List.concat
            [ base.content
                |> List.map
                    (\content ->
                        case content.value of
                            BaseContentValueMarkdown markdown ->
                                div [ class "container" ] [ markdownRender markdown ]

                            BaseContentValueAsset asset ->
                                -- assetView { src = asset.path, alt = asset.title } AssetDefault
                                emptyNode

                            BaseContentValueHero hero ->
                                heroView hero

                            BaseContentValueRow rowItems ->
                                div [ class "container" ] [ rowView rowItems ]

                            _ ->
                                emptyNode
                    )
            ]
        )
