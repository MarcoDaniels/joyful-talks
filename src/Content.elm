module Content exposing (contentDecoder, contentFeed, metadataDecoder)

import Context exposing (Content, Data(..), Metadata, MetadataContext, PageData, StaticRequest)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (assetDecoder, linkDecoder, linkValueDecoder)
import Shared.Types exposing (AssetPath, Base, CookieBanner, Feed, FeedItem, Footer, Meta, Navigation, Post, SEO)


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


contentDecoder : Decoder Content
contentDecoder =
    succeed Content
        |> required "collection" string
        |> custom
            (field "collection" string
                |> andThen
                    (\collection ->
                        case collection of
                            "joyfulPage" ->
                                succeed BaseData |> required "content" baseDecoder

                            "joyfulPost" ->
                                succeed PostData |> required "content" postDecoder

                            _ ->
                                succeed UnknownData
                    )
            )


contentFeed : List String -> StaticHttp.Request Feed
contentFeed categoryList =
    let
        buildFilter : List String -> String
        buildFilter filter =
            filter
                |> List.map (\category -> "&filter[$or][][category]=" ++ category)
                |> String.concat
    in
    StaticHttp.request
        (Secrets.succeed
            (\apiURL apiToken ->
                { url = apiURL ++ "/collections/entries/joyfulPost?" ++ buildFilter categoryList
                , method = "GET"
                , headers = [ ( "Cockpit-Token", apiToken ) ]
                , body = StaticHttp.emptyBody
                }
            )
            |> Secrets.with "COCKPIT_API_URL"
            |> Secrets.with "COCKPIT_API_TOKEN"
        )
        (succeed Feed
            |> required "entries"
                (list
                    (succeed FeedItem
                        |> required "title" string
                        |> required "description" string
                        |> required "url" string
                        |> required "image" assetDecoder
                    )
                )
        )
