module Page.Post exposing (postDecoder, postView)

import Body.Type exposing (ContentValue(..), PostPage, RelatedItem, Written)
import Context exposing (Element)
import Element.Asset exposing (AssetDefaultType(..), AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Markdown exposing (markdownView)
import Element.Row exposing (rowView)
import Element.Share exposing (shareView)
import Html exposing (a, div, h1, h3, h4, iframe, span, text)
import Html.Attributes exposing (class, href, src, title)
import OptimizedDecoder exposing (Decoder, list, map, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (optional, required)
import Shared.Date exposing (decodeDate, formatDate)
import Shared.Decoder exposing (assetDecoder, contentFieldValueDecoder)
import Shared.Ternary exposing (ternary)


postDecoder : Decoder PostPage
postDecoder =
    succeed PostPage
        |> required "title" string
        |> required "description" string
        |> required "url" string
        |> required "image" (maybe assetDecoder)
        |> required "content" (maybe (list contentFieldValueDecoder))
        |> required "writtenBy"
            (succeed Written
                |> required "name" string
                |> required "url" (maybe string)
            )
        |> optional "_publishedAt" (map Just decodeDate) Nothing
        |> required "related"
            (maybe
                (list
                    (succeed RelatedItem
                        |> required "title" string
                        |> required "url" string
                        |> required "image" assetDecoder
                    )
                )
            )


postView : PostPage -> Element
postView post =
    div [ class "post" ]
        (List.concat
            [ List.singleton (h1 [] [ text post.title ])
            , case post.content of
                Just postContent ->
                    postContent
                        |> List.map
                            (\content ->
                                case content.value of
                                    ContentValueMarkdown markdown ->
                                        markdownView markdown

                                    ContentValueAsset image ->
                                        assetView { src = image.path, alt = image.title }
                                            (ternary (image.width >= image.height)
                                                (AssetDefault AssetDefaultLandscape)
                                                (AssetDefault AssetDefaultPortrait)
                                            )

                                    ContentValueRow rowItems ->
                                        rowView rowItems

                                    ContentValueIframe frame ->
                                        iframe
                                            [ src frame.source
                                            , title frame.title
                                            , class ("post-frame-" ++ frame.ratio)
                                            ]
                                            []

                                    _ ->
                                        emptyNode
                            )

                Nothing ->
                    [ emptyNode ]
            , [ div [ class "post-info font-m" ]
                    [ div []
                        [ span [] [ text "written by " ]
                        , case post.written.url of
                            Just url ->
                                a [ class "link-tertiary", href url ] [ text post.written.name ]

                            Nothing ->
                                span [] [ text post.written.name ]
                        ]
                    , case post.published of
                        Just published ->
                            div [] [ text (formatDate published) ]

                        Nothing ->
                            emptyNode
                    ]
              , shareView post
              , case post.related of
                    Just relatedItems ->
                        div [ class "post-related" ]
                            [ h3 [ class "post-related-headline" ] [ span [] [ text "you might also like" ] ]
                            , div [ class "post-related-item" ]
                                (relatedItems
                                    |> List.map
                                        (\item ->
                                            a [ class "link-primary", href item.url ]
                                                [ assetView { src = item.asset.path, alt = item.asset.title } AssetRelated
                                                , div [ class "post-related-item-title" ] [ h4 [] [ text item.title ] ]
                                                ]
                                        )
                                )
                            ]

                    Nothing ->
                        emptyNode
              ]
            ]
        )
