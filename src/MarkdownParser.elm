module MarkdownParser exposing (document)

import Html exposing (Html)
import Json.Decode
import Markdown.Parser
import Markdown.Renderer
import Metadata exposing (Metadata)


document :
    { extension : String
    , metadata : Json.Decode.Decoder Metadata
    , body : String -> Result error (List (Html msg))
    }
document =
    { extension = "md"
    , metadata = Metadata.decoder
    , body =
        \markdownBody ->
            Markdown.Parser.parse markdownBody
                |> Result.withDefault []
                |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
                |> Result.withDefault [ Html.text "" ]
                |> Html.div []
                |> List.singleton
                |> Ok
    }
