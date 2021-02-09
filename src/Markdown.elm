module Markdown exposing (markdownRender)

import Html exposing (Html)
import Markdown.Parser
import Markdown.Renderer


markdownRender : String -> Html msg
markdownRender markdownBody =
    Markdown.Parser.parse markdownBody
        |> Result.withDefault []
        |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
        |> Result.withDefault [ Html.text "" ]
        |> Html.div []
