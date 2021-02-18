module Content exposing (contentDecoder, contentView)

import Context exposing (Content, ContentContext, Data(..), PageData, StaticRequest)
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Layout
import Metadata exposing (metadataHead)
import OptimizedDecoder as Decoder
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Shared.Decoder exposing (linkDecoder)
import Shared.Types exposing (Base, CookieInformation, Meta, Post)


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



-- TODO: implement feed fetch and filter


request : StaticHttp.Request String
request =
    StaticHttp.get
        (Secrets.succeed
            "https://api.github.com/repos/marcodaniels/joyful-talks"
        )
        (Decoder.field "full_name" Decoder.string)


contentView :
    Maybe (List String)
    -> ContentContext
    -> PageData
    -> StaticHttp.Request StaticRequest
contentView maybeFeed contentContext pageData =
    case maybeFeed of
        Just feed ->
            request
                |> StaticHttp.map
                    (\_ ->
                        { view = \model _ -> Layout.view pageData contentContext model
                        , head = metadataHead contentContext
                        }
                    )

        Nothing ->
            StaticHttp.succeed
                { view = \model _ -> Layout.view pageData contentContext model
                , head = metadataHead contentContext
                }
