module Markdown exposing (markdownRender)

import Context exposing (Element)
import Html exposing (Html)
import Markdown.Parser
import Markdown.Renderer



-- TODO: markdown should handle links


markdownRender : String -> Element
markdownRender markdownBody =
    Markdown.Parser.parse markdownBody
        |> Result.withDefault []
        |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
        |> Result.withDefault [ Html.text "" ]
        |> Html.div []
