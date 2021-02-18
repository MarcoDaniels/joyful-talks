module Content exposing (contentDecoder, contentFeed)

import Context exposing (Content, ContentContext, Data(..), PageData, StaticRequest)
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import OptimizedDecoder as Decoder
import OptimizedDecoder.Pipeline as Decoder
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (linkDecoder)
import Shared.Types exposing (Base, CookieInformation, Feed, FeedItem, Meta, Post)


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
                |> required "navigation" (list linkDecoder)
                |> required "footer" (list linkDecoder)
                |> required "cookie" (succeed CookieInformation |> required "title" string |> required "content" string)
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
        (Decoder.succeed Feed
            |> Decoder.required "entries"
                (Decoder.list
                    (Decoder.succeed FeedItem
                        |> Decoder.required "title" Decoder.string
                        |> Decoder.required "description" Decoder.string
                        |> Decoder.required "url" Decoder.string
                    )
                )
        )
