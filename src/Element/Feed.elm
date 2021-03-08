module Element.Feed exposing (feedView)

import Context exposing (Element)
import Element.Image exposing (ImageType(..), imageView)
import Html exposing (a, div, h2, p, text)
import Html.Attributes exposing (class, href)
import Shared.Ternary exposing (ternary)
import Shared.Types exposing (Feed)


feedView : Feed -> Element
feedView feed =
    div [ class "feed container" ]
        (feed.entries
            |> List.map
                (\item ->
                    a
                        [ class (ternary (item.image.width >= item.image.height) "landscape" "portrait")
                        , href item.url
                        ]
                        [ div [ class "feed-item" ]
                            [ imageView { src = item.image.path, alt = item.title } ImageFeed
                            , div [ class "feed-text" ]
                                [ h2 [ class "font-l" ] [ text item.title ]
                                , p [ class "feed-text-description font-m" ] [ text item.description ]
                                ]
                            ]
                        ]
                )
        )
