module ContentFeed exposing (contentFeed)

import OptimizedDecoder exposing (Decoder, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (assetDecoder)
import Shared.Types exposing (AssetPath, BasePage, CookieBanner, Feed, FeedItem, Footer, Meta, Navigation, PostPage, SEO)


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
