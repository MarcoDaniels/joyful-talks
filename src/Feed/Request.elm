module Feed.Request exposing (requestFeed)

import Feed.Type exposing (Feed, FeedItem)
import OptimizedDecoder exposing (list, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (assetDecoder)


requestFeed : List String -> StaticHttp.Request Feed
requestFeed categoryList =
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
                { url = apiURL ++ "/collections/entries/joyfulPost?" ++ buildFilter categoryList ++ "&sort[_publishedAt]=-1"
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
