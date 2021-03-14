module Metadata.Decoder exposing (metadataDecoder)

import Metadata.Type exposing (BasePageMeta, CookieBanner, Footer, Metadata(..), Navigation, PageMetadata, PostPageMeta, Settings)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (linkDecoder, linkValueDecoder)


settingsDecoder : Decoder Settings
settingsDecoder =
    succeed Settings
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


metadataDecoder : Decoder PageMetadata
metadataDecoder =
    succeed PageMetadata
        |> required "collection" string
        |> custom
            (field "collection" string
                |> andThen
                    (\collection ->
                        case collection of
                            "joyfulPage" ->
                                succeed MetadataBase
                                    |> required "meta"
                                        (succeed BasePageMeta
                                            |> required "title" string
                                            |> required "description" string
                                            |> required "feed" (maybe (list string))
                                            |> required "settings" settingsDecoder
                                        )

                            "joyfulPost" ->
                                succeed MetadataPost
                                    |> required "meta"
                                        (succeed PostPageMeta
                                            |> required "title" string
                                            |> required "description" string
                                            |> required "settings" settingsDecoder
                                        )

                            _ ->
                                succeed MetadataUnknown
                    )
            )
