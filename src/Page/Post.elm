module Page.Post exposing (postDecoder, postView)

import Body.Type exposing (ContentValue(..), PostPage, RelatedItem, Written)
import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Markdown exposing (markdownView)
import Element.Row exposing (rowView)
import Element.Share exposing (shareView)
import Html exposing (a, div, h1, h4, iframe, span, text)
import Html.Attributes exposing (class, href, src, title)
import OptimizedDecoder exposing (Decoder, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Shared.Date exposing (decodeDate, formatDate)
import Shared.Decoder exposing (assetDecoder, contentFieldValueDecoder)


postDecoder : Decoder PostPage
postDecoder =
    succeed PostPage
        |> required "title" string
        |> required "description" string
        |> required "url" string
        |> required "image" assetDecoder
        |> required "content" (list contentFieldValueDecoder)
        |> required "writtenBy"
            (succeed Written
                |> required "name" string
                |> required "url" (maybe string)
            )
        |> required "_modified" decodeDate
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
            [ List.singleton (h1 [ class "post-title font-xl" ] [ text post.title ])
            , post.content
                |> List.map
                    (\content ->
                        case content.value of
                            ContentValueMarkdown markdown ->
                                markdownView markdown

                            ContentValueAsset image ->
                                assetView { src = image.path, alt = image.title } AssetPost

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
            , [ div [ class "post-info font-m" ]
                    [ div []
                        [ span [] [ text "written by " ]
                        , case post.written.url of
                            Just url ->
                                a [ class "link-tertiary", href url ] [ text post.written.name ]

                            Nothing ->
                                span [] [ text post.written.name ]
                        ]
                    , div [] [ text (formatDate post.updated) ]
                    ]
              , shareView post
              , case post.related of
                    Just relatedItems ->
                        div [ class "post-related" ]
                            [ h4 [ class "post-related-headline" ] [ span [] [ text "you might also like" ] ]
                            , div [ class "post-related-item" ]
                                (relatedItems
                                    |> List.map
                                        (\item ->
                                            a [ class "link-primary", href item.url ]
                                                [ assetView { src = item.asset.path, alt = item.asset.title } AssetRelated
                                                , div [ class "post-related-item-title" ] [ text item.title ]
                                                ]
                                        )
                                )
                            ]

                    Nothing ->
                        emptyNode
              ]
            ]
        )
