module Element.Feed exposing (feedView)

import Context exposing (Msg)
import Element.Image exposing (ImageType(..), imageView)
import Html exposing (Html, a, div, h4, p, text)
import Html.Attributes exposing (class, href)
import Shared.Ternary exposing (ternary)
import Shared.Types exposing (Feed)


feedView : Feed -> Html Msg
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
                                [ h4 [] [ text item.title ]
                                , p [] [ text item.description ]
                                ]
                            ]
                        ]
                )
        )
