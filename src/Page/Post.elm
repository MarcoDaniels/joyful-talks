module Page.Post exposing (postDecoder, postView)

import Context exposing (PageData)
import Element.Empty exposing (emptyNode)
import Element.Asset exposing (AssetType(..), assetView)
import Html
import Html.Attributes
import Markdown exposing (markdownRender)
import OptimizedDecoder exposing (Decoder, andThen, field, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (fieldDecoder, assetDecoder)
import Shared.Types exposing (Field, Post, PostContent, PostContentRepeaterField, PostContentRepeaterType(..), PostContentValue(..))


repeaterFieldDecoder : Decoder PostContentRepeaterField
repeaterFieldDecoder =
    succeed PostContentRepeaterField
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case field.fieldType of
                            "markdown" ->
                                succeed PostContentRepeaterMarkdown |> required "value" string

                            "image" ->
                                succeed PostContentRepeaterAsset |> required "value" assetDecoder

                            _ ->
                                succeed PostContentRepeaterUnknown
                    )
            )


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
                                    case field.fieldType of
                                        "markdown" ->
                                            succeed PostContentValueMarkdown |> required "value" string

                                        "image" ->
                                            succeed PostContentValueAsset |> required "value" assetDecoder

                                        "repeater" ->
                                            succeed PostContentValueRepeater |> required "value" (list repeaterFieldDecoder)

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
        Html.div [ Html.Attributes.class "center" ]
            (post.content
                |> List.map
                    (\content ->
                        case content.value of
                            PostContentValueMarkdown markdown ->
                                markdownRender markdown

                            PostContentValueAsset image ->
                                assetView { src = image.path, alt = "" } AssetPost

                            PostContentValueRepeater repeater ->
                                Html.div [ Html.Attributes.class "side" ]
                                    (repeater
                                        |> List.map
                                            (\rep ->
                                                case rep.value of
                                                    PostContentRepeaterMarkdown markdown ->
                                                        markdownRender markdown

                                                    PostContentRepeaterAsset image ->
                                                        assetView { src = image.path, alt = "" } AssetDefault

                                                    PostContentRepeaterUnknown ->
                                                        emptyNode
                                            )
                                    )

                            PostContentValueUnknown ->
                                emptyNode
                    )
            )
    }
