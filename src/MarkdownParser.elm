module MarkdownParser exposing (..)

import Html exposing (Html)
import Json.Decode as Decode
import Markdown.Parser
import Markdown.Renderer



-- markdown parser not used for body
-- as body is derived from frontmatter


dec : String -> Result error (List (Html msg))
dec content =
    Html.div [] [ Html.text content ]
        |> List.singleton
        |> Ok


decode : String -> Result error (List (Html msg))
decode body =
    case Decode.decodeString (Decode.field "content" Decode.string) body of
        Ok content ->
            Html.text content
                |> List.singleton
                |> Ok

        Err error ->
            Html.text ("Error: " ++ Decode.errorToString error)
                |> List.singleton
                |> Ok


decodeMarkdown : String -> Result error (List (Html msg))
decodeMarkdown markdownBody =
    Markdown.Parser.parse markdownBody
        |> Result.withDefault []
        |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
        |> Result.withDefault [ Html.text "" ]
        |> Html.div []
        |> List.singleton
        |> Ok
