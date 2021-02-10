module Data.Decoder exposing (..)

import Data.Types exposing (..)
import Json.Decode exposing (Decoder, list, map, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)


fieldTypeDecoder : Decoder Field
fieldTypeDecoder =
    succeed Field
        |> required "type" string


contentTextDecoder : Decoder BaseContentTextField
contentTextDecoder =
    succeed BaseContentTextField
        |> required "field" fieldTypeDecoder
        |> required "value" string


contentImageDecoder : Decoder BaseContentImageField
contentImageDecoder =
    succeed BaseContentImageField
        |> required "field" fieldTypeDecoder
        |> required "value"
            (succeed ImagePath
                |> required "path" string
            )


contentDecoder : Decoder BaseContent
contentDecoder =
    oneOf
        [ contentTextDecoder
            |> map BaseContentText
        , contentImageDecoder
            |> map BaseContentImage
        , succeed BaseContentEmpty
        ]


pageDecoder : Decoder Base
pageDecoder =
    succeed Base
        |> required "pageType" string
        |> required "title" string
        |> required "description" string
        |> required "content" (list contentDecoder)
