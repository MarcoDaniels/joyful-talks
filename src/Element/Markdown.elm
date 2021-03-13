module Element.Markdown exposing (markdownView)

import Context exposing (Element)
import Html exposing (Attribute, a)
import Html.Attributes as Attributes
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, defaultHtmlRenderer, render)
import Result
import Shared.Ternary exposing (ternary)


{-| Open in new tab when links contains protocol
-}
linkAttributes : String -> List (Attribute msg) -> List (Attribute msg)
linkAttributes href attributes =
    ternary (String.startsWith href "https://" || String.startsWith href "http://")
        (List.concat
            [ attributes
            , [ Attributes.target "_blank"
              , Attributes.rel "noopener noreferrer"
              , Attributes.class "link-secondary"
              , Attributes.href href
              ]
            ]
        )
        (List.concat
            [ attributes
            , [ Attributes.class "link-secondary"
              , Attributes.href href
              ]
            ]
        )


markdownRenderer : Renderer Element
markdownRenderer =
    { defaultHtmlRenderer
        | link =
            \link content ->
                case link.title of
                    Just title ->
                        a (linkAttributes link.destination [ Attributes.title title ]) content

                    Nothing ->
                        a (linkAttributes link.destination []) content
    }


markdownView : String -> Element
markdownView input =
    parse input
        |> Result.withDefault []
        |> render markdownRenderer
        |> Result.withDefault []
        |> Html.div []
