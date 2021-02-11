module Data.Decoder exposing (pageDecoder)

import Data.Types exposing (..)
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field
        |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath
        |> required "path" string


baseContentValueDecoder : Field -> Decoder BaseContentValue
baseContentValueDecoder field =
    case field.fieldType of
        "text" ->
            succeed BaseContentValueText
                |> required "value" string

        "markdown" ->
            succeed BaseContentValueMarkdown
                |> required "value" string

        "image" ->
            succeed BaseContentValueImage
                |> required "value" imageDecoder

        _ ->
            succeed BaseContentValueUnknown


baseContentDecoder : Decoder BaseContent
baseContentDecoder =
    succeed BaseContent
        |> required "field" fieldDecoder
        |> custom (field "field" fieldDecoder |> andThen baseContentValueDecoder)


pageDecoder : Decoder Base
pageDecoder =
    succeed Base
        |> required "pageType" string
        |> required "title" string
        |> required "description" string
        |> required "content" (list baseContentDecoder)
