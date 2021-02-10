module Data.Decoder exposing (..)

import Data.Types exposing (..)
import Json.Decode exposing (Decoder, list, map, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)


fieldTypeDecoder : Decoder Field
fieldTypeDecoder =
    succeed Field
        |> required "type" string


contentTextDecoder : Decoder StandardPageContentText
contentTextDecoder =
    succeed StandardPageContentText
        |> required "field" fieldTypeDecoder
        |> required "value" string


contentImageDecoder : Decoder StandardPageContentImage
contentImageDecoder =
    succeed StandardPageContentImage
        |> required "field" fieldTypeDecoder
        |> required "value"
            (succeed ImagePath
                |> required "path" string
            )


contentDecoder : Decoder StandardPageContent
contentDecoder =
    oneOf
        [ contentTextDecoder
            |> map StandardPageText
        , contentImageDecoder
            |> map StandardPageImage
        , succeed StandardPageEmpty
        ]


pageDecoder : Decoder StandardPage
pageDecoder =
    succeed StandardPage
        |> required "pageType" string
        |> required "title" string
        |> required "description" string
        |> required "content" (list contentDecoder)
