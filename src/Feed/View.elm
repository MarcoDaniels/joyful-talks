module Feed.View exposing (feedView)

import Context exposing (Element)
import Element.Asset exposing (AssetType(..), assetView)
import Feed.Type exposing (Feed)
import Html exposing (a, div, h2, p, text)
import Html.Attributes exposing (class, href)
import Shared.Ternary exposing (ternary)


feedView : Feed -> Element
feedView feed =
    div [ class "feed container" ]
        (feed.entries
            |> List.map
                (\item ->
                    a
                        [ class (ternary (item.asset.width >= item.asset.height) "landscape" "portrait")
                        , href item.url
                        ]
                        [ div [ class "feed-item" ]
                            [ assetView { src = item.asset.path, alt = item.title } AssetFeed
                            , div [ class "feed-text" ]
                                [ h2 [ class "font-l" ] [ text item.title ]
                                , p [ class "feed-text-description" ] [ text item.description ]
                                ]
                            ]
                        ]
                )
        )
