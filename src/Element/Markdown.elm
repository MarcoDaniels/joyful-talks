module Element.Markdown exposing (markdownView)

import Context exposing (Element)
import Html
import Html.Attributes as Attr
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, defaultHtmlRenderer, render)
import Result


markdownRenderer : Renderer Element
markdownRenderer =
    { defaultHtmlRenderer
        | link =
            \link content ->
                case link.title of
                    Just title ->
                        Html.a
                            [ Attr.href link.destination
                            , Attr.title title
                            , Attr.class "link-secondary"
                            ]
                            content

                    Nothing ->
                        Html.a
                            [ Attr.href link.destination
                            , Attr.class "link-secondary"
                            ]
                            content
    }


markdownView : String -> Element
markdownView input =
    parse input
        |> Result.withDefault []
        |> render markdownRenderer
        |> Result.withDefault []
        |> Html.div []
