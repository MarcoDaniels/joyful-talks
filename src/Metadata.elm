module Metadata exposing (PageMetadata, decoder)

import Json.Decode as Decode


type alias PageMetadata =
    { title : String, content : String }


decoder : Decode.Decoder PageMetadata
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\pageType ->
                case pageType of
                    "page" ->
                        Decode.map2 PageMetadata (Decode.field "title" Decode.string) (Decode.field "content" Decode.string)

                    _ ->
                        Decode.fail ("Unexpected page type " ++ pageType)
            )
