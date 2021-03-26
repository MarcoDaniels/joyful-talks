module Element.Row exposing (rowView)

import Body.Type exposing (RowContentField, RowContentValue(..))
import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Element.Empty exposing (emptyNode)
import Element.Markdown exposing (markdownView)
import Html exposing (div)
import Html.Attributes exposing (class)


rowView : List RowContentField -> Element
rowView rowItems =
    div [ class "row" ]
        (rowItems
            |> List.map
                (\item ->
                    case item.value of
                        RowContentMarkdown markdown ->
                            div [] [ markdownView markdown ]

                        RowContentAsset asset ->
                            assetView { src = asset.path, alt = asset.title } (AssetRow (List.length rowItems))

                        RowContentUnknown ->
                            emptyNode
                )
        )
