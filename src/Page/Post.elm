module Page.Post exposing (postDecoder, postView)

import Context exposing (PageData)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Row exposing (rowView)
import Html exposing (a, div, h1, h4, span, text)
import Html.Attributes exposing (class, href)
import Markdown exposing (markdownRender)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Date exposing (decodeDate, formatDate)
import Shared.Decoder exposing (assetDecoder, fieldDecoder, rowContentDecoder)
import Shared.Types exposing (Field, Post, PostContent, PostContentValue(..), RelatedItem, Written)


postDecoder : Decoder Post
postDecoder =
    succeed Post
        |> required "title" string
        |> required "description" string
        |> required "content"
            (list
                (succeed PostContent
                    |> required "field" fieldDecoder
                    |> custom
                        (field "field" fieldDecoder
                            |> andThen
                                (\field ->
                                    case ( field.fieldType, field.label ) of
                                        ( "markdown", _ ) ->
                                            succeed PostContentValueMarkdown
                                                |> required "value" string

                                        ( "asset", _ ) ->
                                            succeed PostContentValueAsset
                                                |> required "value" assetDecoder

                                        ( "repeater", "Row" ) ->
                                            succeed PostContentValueRow
                                                |> required "value" (list rowContentDecoder)

                                        _ ->
                                            succeed PostContentValueUnknown
                                )
                        )
                )
            )
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


postView : Post -> PageData
postView post =
    { title = post.title
    , body =
        div [ class "post" ]
            (List.concat
                [ List.singleton (h1 [ class "post-title font-xl" ] [ text post.title ])
                , post.content
                    |> List.map
                        (\content ->
                            case content.value of
                                PostContentValueMarkdown markdown ->
                                    markdownRender markdown

                                PostContentValueAsset image ->
                                    assetView { src = image.path, alt = image.title } AssetPost

                                PostContentValueRow rowItems ->
                                    rowView rowItems

                                PostContentValueUnknown ->
                                    emptyNode
                        )
                , List.singleton
                    (div [ class "post-info font-m" ]
                        [ div []
                            [ span [] [ text "written by " ]
                            , case post.written.url of
                                Just url ->
                                    a [ class "link-secondary", href url ] [ text post.written.name ]

                                Nothing ->
                                    span [] [ text post.written.name ]
                            ]
                        , div [] [ text (formatDate post.updated) ]
                        ]
                    )
                , List.singleton
                    (case post.related of
                        Just relatedItems ->
                            div [class "post-related" ]
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
                    )
                ]
            )
    }
