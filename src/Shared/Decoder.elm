module Shared.Decoder exposing (fieldDecoder, imageDecoder, linkDecoder)

import Json.Decode exposing (Decoder, string, succeed)
import Json.Decode.Pipeline exposing (required, requiredAt)
import Shared.Types exposing (CookieInformation, Field, ImagePath, Link)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath |> required "path" string


linkDecoder : Decoder Link
linkDecoder =
    succeed Link |> requiredAt [ "value", "title" ] string |> requiredAt [ "value", "url" ] string
