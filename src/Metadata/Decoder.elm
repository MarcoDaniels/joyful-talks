module Metadata.Decoder exposing (metadataDecoder)

import Metadata.Type exposing (BasePageMeta, Metadata(..), PageMetadata, PostPageMeta)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (siteSettingsDecoder)


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
                                            |> required "image" (maybe string)
                                            |> required "feed" (maybe (list string))
                                        )

                            "joyfulPost" ->
                                succeed MetadataPost
                                    |> required "meta"
                                        (succeed PostPageMeta
                                            |> required "title" string
                                            |> required "description" string
                                            |> required "image" (maybe string)
                                        )

                            _ ->
                                succeed MetadataUnknown
                    )
            )
        |> required "site" siteSettingsDecoder
