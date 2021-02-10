module Data.Render exposing (dataRender)

import Context exposing (DataContext, PageContext)
import Data.Types exposing (StandardPage, StandardPageContent(..))
import Html exposing (Html)
import Html.Attributes
import Markdown exposing (markdownRender)
import Pages
import Pages.PagePath exposing (PagePath)


dataRender : List ( PagePath Pages.PathKey, StandardPage ) -> DataContext -> PageContext
dataRender _ data =
    { title = data.frontmatter.title
    , body =
        case data.frontmatter.pageType of
            "page" ->
                Html.div [ Html.Attributes.class "center" ]
                    (data.frontmatter.content
                        |> List.map
                            (\content ->
                                case content of
                                    StandardPageText text ->
                                        case text.field.fieldType of
                                            "text" ->
                                                Html.div [] [ Html.text text.value ]

                                            "markdown" ->
                                                markdownRender text.value

                                            _ ->
                                                Html.div [] []

                                    StandardPageImage image ->
                                        Html.div [] [ Html.img [ Html.Attributes.src image.value.path ] [] ]

                                    StandardPageEmpty ->
                                        Html.div [] []
                            )
                    )

            "post" ->
                --TODO: handle post type
                Html.div [ Html.Attributes.class "center" ] [ Html.text "hey" ]

            _ ->
                Html.div [] []
    }
