module Element.Footer exposing (footerView)

import Context exposing (Element)
import Html exposing (a, div, footer, text)
import Html.Attributes exposing (class, href)
import Markdown exposing (markdownRender)
import Shared.Types exposing (Footer)


footerView : Footer -> Element
footerView footerData =
    footer [ class "footer" ]
        [ div [ class "container center" ]
            [ div [ class "footer-links" ]
                (footerData.links
                    |> List.map
                        (\link ->
                            a [ class "link-primary font-m", href link.url ] [ text link.text ]
                        )
                )
            , div [ class "footer-info" ] [ markdownRender footerData.info ]
            ]
        ]
