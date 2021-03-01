module Element.Footer exposing (footerView)

import Context exposing (Msg)
import Html exposing (Html, a, div, footer, text)
import Html.Attributes exposing (href)
import Markdown exposing (markdownRender)
import Shared.Types exposing (Footer)


footerView : Footer -> Html Msg
footerView footerData =
    footer []
        [ div []
            (footerData.links
                |> List.map
                    (\link ->
                        a [ href link.url ] [ text link.text ]
                    )
            )
        , div [] [ markdownRender footerData.info ]
        ]
