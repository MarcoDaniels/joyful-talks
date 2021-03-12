module Metadata exposing (metadataDecoder)

import Context exposing (Metadata)
import OptimizedDecoder exposing (Decoder, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Shared.Decoder exposing (linkDecoder, linkValueDecoder)
import Shared.Types exposing (CookieBanner, Footer, Meta, Navigation, SEO)


metadataDecoder : Decoder Metadata
metadataDecoder =
    succeed Metadata
        |> required "seo"
            (succeed SEO
                |> required "title" string
                |> required "description" string
            )
        |> required "feed" (maybe (list string))
        |> required "meta"
            (succeed Meta
                |> required "navigation"
                    (succeed Navigation
                        |> required "brand" linkDecoder
                        |> required "menu" (list linkValueDecoder)
                        |> required "social" (list linkValueDecoder)
                    )
                |> required "footer"
                    (succeed Footer
                        |> required "links" (list linkValueDecoder)
                        |> required "info" string
                    )
                |> required "cookie"
                    (succeed CookieBanner
                        |> required "title" string
                        |> required "content" string
                    )
            )
