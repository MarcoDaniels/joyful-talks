module Shared.Decoder exposing (columnContentDecoder, fieldDecoder, assetDecoder, linkDecoder, linkValueDecoder)

import OptimizedDecoder exposing (Decoder, andThen, field, int, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, optional, required, requiredAt)
import Shared.Types exposing (ColumnContent(..), ColumnContentField, CookieBanner, Field, AssetPath, Link)


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


columnContentDecoder : Decoder ColumnContentField
columnContentDecoder =
    succeed ColumnContentField
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case field.fieldType of
                            "markdown" ->
                                succeed ColumnContentMarkdown |> required "value" string

                            "asset" ->
                                succeed ColumnContentAsset |> required "value" assetDecoder

                            _ ->
                                succeed ColumnContentUnknown
                    )
            )
