module Page.Post exposing (postDecoder, postView)

import Context exposing (PageData)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Row exposing (rowView)
import Html exposing (div, h1, text)
import Html.Attributes exposing (class)
import Markdown exposing (markdownRender)
import OptimizedDecoder exposing (Decoder, andThen, field, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (assetDecoder, fieldDecoder, rowContentDecoder)
import Shared.Types exposing (Field, Post, PostContent, PostContentValue(..))


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
                                    assetView { src = image.path, alt = "" } AssetPost

                                PostContentValueRow rowItems ->
                                    rowView rowItems

                                PostContentValueUnknown ->
                                    emptyNode
                        )
                ]
            )
    }
