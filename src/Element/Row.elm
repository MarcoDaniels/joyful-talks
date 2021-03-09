module Element.Row exposing (rowView)

import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown exposing (markdownRender)
import Shared.Types exposing (ColumnContent(..), ColumnContentField)


rowView : List ColumnContentField -> Element
rowView columns =
    div [ class "row" ]
        (columns
            |> List.map
                (\column ->
                    case column.value of
                        ColumnContentMarkdown markdown ->
                            markdownRender markdown

                        ColumnContentAsset asset ->
                            assetView { src = asset.path, alt = asset.title } (AssetRow (List.length columns))

                        ColumnContentUnknown ->
                            emptyNode
                )
        )
