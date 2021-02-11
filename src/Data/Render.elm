module Data.Render exposing (dataRender)

import Context exposing (DataContext, PageContext)
import Data.Types exposing (Base, BaseContentValue(..))
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

            "post" ->
                --TODO: handle post type
                Html.div [ Html.Attributes.class "center" ] [ Html.text "hey" ]

            _ ->
                Html.div [] []
    }
