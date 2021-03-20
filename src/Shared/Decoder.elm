module Shared.Decoder exposing (assetDecoder, contentFieldValueDecoder, fieldDecoder, linkDecoder, linkValueDecoder, rowContentDecoder)

import Body.Type exposing (ContentFieldValue, ContentValue(..), HeroContent, RowContentField, RowContentValue(..))
import OptimizedDecoder exposing (Decoder, andThen, field, int, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, optional, required, requiredAt)
import Shared.Type exposing (AssetPath, Field, Link)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field
        |> required "type" string
        |> required "label" string


assetDecoder : Decoder AssetPath
assetDecoder =
    succeed AssetPath
        |> required "path" string
        |> required "title" string
        |> required "width" int
        |> required "height" int
        |> optional "colors" (maybe (list string)) Nothing


linkDecoder : Decoder Link
linkDecoder =
    succeed Link |> required "title" string |> required "url" string


linkValueDecoder : Decoder Link
linkValueDecoder =
    succeed Link |> requiredAt [ "value", "title" ] string |> requiredAt [ "value", "url" ] string


rowContentDecoder : Decoder RowContentField
rowContentDecoder =
    succeed RowContentField
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case field.fieldType of
                            "markdown" ->
                                succeed RowContentMarkdown |> required "value" string

                            "asset" ->
                                succeed RowContentAsset |> required "value" assetDecoder

                            _ ->
                                succeed RowContentUnknown
                    )
            )


contentFieldValueDecoder : Decoder ContentFieldValue
contentFieldValueDecoder =
    succeed ContentFieldValue
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case ( field.fieldType, field.label ) of
                            ( "markdown", _ ) ->
                                succeed ContentValueMarkdown
                                    |> required "value" string

                            ( "asset", _ ) ->
                                succeed ContentValueAsset
                                    |> required "value" assetDecoder

                            ( "set", "Hero" ) ->
                                succeed ContentValueHero
                                    |> required "value"
                                        (succeed HeroContent
                                            |> required "image" assetDecoder
                                            |> required "text" (maybe string)
                                        )

                            ( "repeater", "Row" ) ->
                                succeed ContentValueRow
                                    |> required "value" (list rowContentDecoder)

                            _ ->
                                succeed ContentValueUnknown
                    )
            )
