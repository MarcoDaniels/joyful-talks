module Content exposing (Content, ContentContext, Data(..), contentDecoder, contentView)

import MainContext exposing (PageContext)
import Html
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder, baseView)
import Page.Post exposing (postDecoder, postView)
import Pages
import Pages.PagePath exposing (PagePath)
import Shared.Decoder exposing (linkDecoder)
import Shared.Types exposing (Base, CookieInformation, Meta, Post)


type alias ContentContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Content
    }


type Data
    = BaseData Base
    | PostData Post
    | UnknownData


type alias Content =
    { collection : String, data : Data, meta : Meta }


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
                            "base" ->
                                succeed BaseData |> required "data" baseDecoder

                            "post" ->
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


contentView : ContentContext -> PageContext
contentView data =
    case data.frontmatter.data of
        BaseData base ->
            baseView base

        PostData post ->
            postView post

        UnknownData ->
            { title = "", body = Html.div [] [] }
