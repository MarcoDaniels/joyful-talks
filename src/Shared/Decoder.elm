module Shared.Decoder exposing (fieldDecoder, imageDecoder)

import Shared.Types exposing (Field, ImagePath)
import Json.Decode exposing (Decoder, string, succeed)
import Json.Decode.Pipeline exposing (required)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field |> required "type" string


imageDecoder : Decoder ImagePath
imageDecoder =
    succeed ImagePath |> required "path" string
