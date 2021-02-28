module Element.Feed exposing (feedView)

import Context exposing (Msg)
import Element.Image exposing (imageView)
import Html exposing (Html, a, div, h4, p, text)
import Html.Attributes exposing (class, href)
import Shared.Types exposing (Feed)


feedView : Feed -> Html Msg
feedView feed =
    div [ class "feed" ]
        (feed.entries
            |> List.map
                (\item ->
                    a [ href item.url ]
                        [ div []
                            [ h4 [] [ text item.title ]
                            , imageView item.image.path
                            , p [] [ text item.description ]
                            ]
                        ]
                )
        )
