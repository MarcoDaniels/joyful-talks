module Data.Render exposing (dataRender)

import Context exposing (DataContext, PageContext)
import Data.Types exposing (Base, BaseContentValue(..), Data, DataContent(..), PostContentRepeaterType(..), PostContentValue(..))
import Html exposing (Html)
import Html.Attributes
import Markdown exposing (markdownRender)


dataRender : DataContext -> PageContext
dataRender data =
    case data.frontmatter.data of
        BaseData base ->
            { title = base.title
            , body =
                Html.div [ Html.Attributes.class "center" ]
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
            }

        PostData post ->
            { title = post.title
            , body =
                Html.div [ Html.Attributes.class "center" ]
                    (post.content
                        |> List.map
                            (\content ->
                                case content.value of
                                    PostContentValueMarkdown markdown ->
                                        markdownRender markdown

                                    PostContentValueImage image ->
                                        Html.img [ Html.Attributes.src image.path ] []

                                    PostContentValueRepeater repeater ->
                                        Html.div []
                                            (repeater
                                                |> List.map
                                                    (\rep ->
                                                        case rep.value of
                                                            PostContentRepeaterMarkdown markdown ->
                                                                markdownRender markdown

                                                            PostContentRepeaterImage image ->
                                                                Html.img [ Html.Attributes.src image.path ] []

                                                            PostContentRepeaterUnknown ->
                                                                Html.div [] []
                                                    )
                                            )

                                    PostContentValueUnknown ->
                                        Html.div [] []
                            )
                    )
            }

        UnknownData ->
            { title = "", body = Html.div [] [] }
