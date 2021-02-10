module Data.Render exposing (dataRender)

import Context exposing (DataContext, PageContext)
import Data.Types exposing (Base, BaseContent(..))
import Html exposing (Html)
import Html.Attributes
import Markdown exposing (markdownRender)
import Pages
import Pages.PagePath exposing (PagePath)


dataRender : List ( PagePath Pages.PathKey, Base ) -> DataContext -> PageContext
dataRender _ data =
    { title = data.frontmatter.title
    , body =
        case data.frontmatter.pageType of
            "base" ->
                Html.div [ Html.Attributes.class "center" ]
                    (data.frontmatter.content
                        |> List.map
                            (\content ->
                                case content of
                                    BaseContentText text ->
                                        case text.field.fieldType of
                                            "text" ->
                                                Html.div [] [ Html.text text.value ]

                                            "markdown" ->
                                                markdownRender text.value

                                            _ ->
                                                Html.div [] []

                                    BaseContentImage image ->
                                        Html.div [] [ Html.img [ Html.Attributes.src image.value.path ] [] ]

                                    BaseContentEmpty ->
                                        Html.div [] []
                            )
                    )

            "post" ->
                --TODO: handle post type
                Html.div [ Html.Attributes.class "center" ] [ Html.text "hey" ]

            _ ->
                Html.div [] []
    }
