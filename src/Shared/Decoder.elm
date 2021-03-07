module Shared.Decoder exposing (fieldDecoder, imageDecoder, linkDecoder, linkValueDecoder)

import OptimizedDecoder exposing (Decoder, int, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (optional, required, requiredAt)
import Shared.Types exposing (CookieBanner, Field, ImagePath, Link)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath
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
