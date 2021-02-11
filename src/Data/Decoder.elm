module Data.Decoder exposing (dataDecoder)

import Data.Types exposing (..)
import Json.Decode exposing (Decoder, andThen, field, list, map, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath |> required "path" string


baseContentValueDecoder : Field -> Decoder BaseContentValue
baseContentValueDecoder field =
    case field.fieldType of
        "text" ->
            succeed BaseContentValueText |> required "value" string

        "markdown" ->
            succeed BaseContentValueMarkdown |> required "value" string

        "image" ->
            succeed BaseContentValueImage |> required "value" imageDecoder

        _ ->
            succeed BaseContentValueUnknown


baseContentDecoder : Decoder BaseContent
baseContentDecoder =
    succeed BaseContent
        |> required "field" fieldDecoder
        |> custom (field "field" fieldDecoder |> andThen baseContentValueDecoder)


baseDecoder : Decoder Base
baseDecoder =
    succeed Base
        |> required "title" string
        |> required "description" string
        |> required "content" (list baseContentDecoder)


postContentRepeaterDecoder : Field -> Decoder PostContentRepeaterType
postContentRepeaterDecoder field =
    case field.fieldType of
        "markdown" ->
            succeed PostContentRepeaterMarkdown |> required "value" string

        "image" ->
            succeed PostContentRepeaterImage |> required "value" imageDecoder

        _ ->
            succeed PostContentRepeaterUnknown


postContentRepeaterFieldDecoder : Decoder PostContentRepeaterField
postContentRepeaterFieldDecoder =
    succeed PostContentRepeaterField
        |> required "field" fieldDecoder
        |> custom (field "field" fieldDecoder |> andThen postContentRepeaterDecoder)


postContentValueDecoder : Field -> Decoder PostContentValue
postContentValueDecoder field =
    case field.fieldType of
        "markdown" ->
            succeed PostContentValueMarkdown |> required "value" string

        "image" ->
            succeed PostContentValueImage |> required "value" imageDecoder

        "repeater" ->
            succeed PostContentValueRepeater |> required "value" (list postContentRepeaterFieldDecoder)

        _ ->
            succeed PostContentValueUnknown


postContentDecoder : Decoder PostContent
postContentDecoder =
    succeed PostContent
        |> required "field" fieldDecoder
        |> custom (field "field" fieldDecoder |> andThen postContentValueDecoder)


postDecoder : Decoder Post
postDecoder =
    succeed Post
        |> required "title" string
        |> required "description" string
        |> required "content" (list postContentDecoder)


dataDecoder : Decoder Data
dataDecoder =
    succeed Data
        |> required "pageType" string
        |> custom
            (field "pageType" string
                |> andThen
                    (\pageType ->
                        case pageType of
                            "base" ->
                                succeed BaseData |> required "data" baseDecoder

                            "post" ->
                                succeed PostData |> required "data" postDecoder

                            _ ->
                                succeed UnknownData
                    )
            )
