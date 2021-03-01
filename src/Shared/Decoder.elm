module Shared.Decoder exposing (fieldDecoder, imageDecoder, linkDecoder)

import OptimizedDecoder exposing (Decoder, string, succeed)
import OptimizedDecoder.Pipeline exposing (required, requiredAt)
import Shared.Types exposing (CookieBanner, Field, ImagePath, Link)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath |> required "path" string


linkDecoder : Decoder Link
linkDecoder =
    succeed Link |> requiredAt [ "value", "title" ] string |> requiredAt [ "value", "url" ] string
