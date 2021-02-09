module Page.Render exposing (pageRender)

import Context exposing (DataContext, PageContext)
import Html exposing (Html)
import Html.Attributes
import Markdown exposing (markdownRender)
import Page.Decoder as Decoder exposing (PageContent(..))
import Pages
import Pages.PagePath exposing (PagePath)


pageRender : List ( PagePath Pages.PathKey, Decoder.Page ) -> DataContext -> PageContext
pageRender _ data =
    { title = data.frontmatter.title
    , body =
        Html.div [ Html.Attributes.class "center" ]
            (data.frontmatter.content
                |> List.map
                    (\content ->
                        case content of
                            TextContent text ->
                                case text.field.fieldType of
                                    "text" ->
                                        Html.div [] [ Html.text text.value ]

                                    "markdown" ->
                                        markdownRender text.value

                                    _ ->
                                        Html.div [] []

                            ImageContent image ->
                                Html.div [] [ Html.img [ Html.Attributes.src image.value.path ] [] ]

                            EmptyContent ->
                                Html.div [] []
                    )
            )
    }
