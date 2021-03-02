module Element.Footer exposing (footerView)

import Context exposing (Msg)
import Html exposing (Html, a, div, footer, text)
import Html.Attributes exposing (class, href)
import Markdown exposing (markdownRender)
import Shared.Types exposing (Footer)


footerView : Footer -> Html Msg
footerView footerData =
    footer [ class "footer" ]
        [ div [ class "container" ]
            [ div [ class "footer-links" ]
                (footerData.links
                    |> List.map
                        (\link ->
                            a [ href link.url ] [ text link.text ]
                        )
                )
            , div [ class "footer-info" ] [ markdownRender footerData.info ]
            ]
        ]
