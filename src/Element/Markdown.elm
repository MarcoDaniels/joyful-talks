module Element.Markdown exposing (markdownView)

import Context exposing (Element)
import Html exposing (Attribute, a, h1, h2, h3, h4, h5, h6)
import Html.Attributes as Attributes exposing (id)
import Markdown.Block as Block
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, defaultHtmlRenderer, render)
import Result
import Shared.Ternary exposing (ternary)


{-| Open in new tab when links contains protocol
-}
linkAttributes : String -> List (Attribute msg) -> List (Attribute msg)
linkAttributes href attributes =
    ternary (String.startsWith "https://" href || String.startsWith "http://" href)
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


textToId : String -> String
textToId text =
    String.words text
        |> String.join "-"
        |> String.toLower


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
        , heading =
            \{ level, rawText, children } ->
                case level of
                    Block.H1 ->
                        h1 [ id (textToId rawText) ] children

                    Block.H2 ->
                        h2 [ id (textToId rawText) ] children

                    Block.H3 ->
                        h3 [ id (textToId rawText) ] children

                    Block.H4 ->
                        h4 [ id (textToId rawText) ] children

                    Block.H5 ->
                        h5 [ id (textToId rawText) ] children

                    Block.H6 ->
                        h6 [ id (textToId rawText) ] children
    }


markdownView : String -> Element
markdownView input =
    parse input
        |> Result.withDefault []
        |> render markdownRenderer
        |> Result.withDefault []
        |> Html.div []
