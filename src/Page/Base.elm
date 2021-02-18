module Page.Base exposing (baseDecoder, baseView)

import Context exposing (PageData)
import Html
import Html.Attributes
import Json.Decode exposing (Decoder, andThen, field, list, maybe, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Markdown exposing (markdownRender)
import Shared.Decoder exposing (fieldDecoder, imageDecoder)
import Shared.Types exposing (Base, BaseContent, BaseContentValue(..), Feed, Field)


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
                                    case field.fieldType of
                                        "text" ->
                                            succeed BaseContentValueText |> required "value" string

                                        "markdown" ->
                                            succeed BaseContentValueMarkdown |> required "value" string

                                        "image" ->
                                            succeed BaseContentValueImage |> required "value" imageDecoder

                                        _ ->
                                            succeed BaseContentValueUnknown
                                )
                        )
                )
            )


baseView : Base -> Maybe Feed -> PageData
baseView base maybeFeed =
    { title = base.title
    , body =
        Html.div []
            [ Html.div [ Html.Attributes.class "center" ]
                (base.content
                    |> List.map
                        (\content ->
                            case content.value of
                                BaseContentValueMarkdown markdown ->
                                    markdownRender markdown

                                BaseContentValueText text ->
                                    Html.text text

                                BaseContentValueImage image ->
                                    Html.img [ Html.Attributes.src image.path ] []

                                BaseContentValueUnknown ->
                                    Html.div [] []
                        )
                )
            , case maybeFeed of
                Just feed ->
                    Html.div [ Html.Attributes.class "feed" ]
                        (feed.entries
                            |> List.map
                                (\gridItem ->
                                    Html.a [ Html.Attributes.href gridItem.url ]
                                        [ Html.div []
                                            [ Html.h4 [] [ Html.text gridItem.title ]
                                            , Html.p [] [ Html.text gridItem.description ]
                                            ]
                                        ]
                                )
                        )

                Nothing ->
                    Html.div [] []
            ]
    }
