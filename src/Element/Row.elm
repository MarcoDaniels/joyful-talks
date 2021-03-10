module Element.Row exposing (rowView)

import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Html exposing (div)
import Html.Attributes exposing (class)
import Markdown exposing (markdownRender)
import Shared.Types exposing (RowContentField, RowContentValue(..))


rowView : List RowContentField -> Element
rowView rowItems =
    div [ class "row" ]
        (rowItems
            |> List.map
                (\item ->
                    case item.value of
                        RowContentMarkdown markdown ->
                            markdownRender markdown

                        RowContentAsset asset ->
                            assetView { src = asset.path, alt = asset.title } (AssetRow (List.length rowItems))

                        RowContentUnknown ->
                            emptyNode
                )
        )
