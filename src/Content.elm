module Content exposing (contentDecoder, contentFeed)

import Context exposing (Content, ContentContext, Data(..), PageData, StaticRequest)
import OptimizedDecoder exposing (Decoder, andThen, field, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (imageDecoder, linkDecoder)
import Shared.Types exposing (Base, CookieBanner, Feed, FeedItem, Footer, ImagePath, Meta, Navigation, Post)


contentDecoder : Decoder Content
contentDecoder =
    succeed Content
        |> required "collection" string
        |> custom
            -- decoding "data" object based on collection
            (field "collection" string
                |> andThen
                    (\collection ->
                        case collection of
                            "joyfulPage" ->
                                succeed BaseData |> required "data" baseDecoder

                            "joyfulPost" ->
                                succeed PostData |> required "data" postDecoder

                            _ ->
                                succeed UnknownData
                    )
            )
        |> required "meta"
            (succeed Meta
                |> required "navigation"
                    (succeed Navigation |> required "menu" (list linkDecoder))
                |> required "footer"
                    (succeed Footer
                        |> required "links" (list linkDecoder)
                        |> required "info" string
                    )
                |> required "cookie"
                    (succeed CookieBanner
                        |> required "title" string
                        |> required "content" string
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
                        |> required "image" imageDecoder
                    )
                )
        )
