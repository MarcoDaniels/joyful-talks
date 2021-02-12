module Data exposing (Data, DataContent(..), DataContext, dataDecoder, dataView)

import Context exposing (PageContext)
import Html
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Pages
import Pages.Base exposing (baseDecoder, baseView)
import Pages.PagePath exposing (PagePath)
import Pages.Post exposing (postDecoder, postView)
import Shared.Decoder exposing (linkDecoder)
import Shared.Types exposing (Base, CookieInformation, Meta, Post)


type alias DataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Data
    }


type DataContent
    = BaseData Base
    | PostData Post
    | UnknownData


type alias Data =
    { collection : String, data : DataContent, meta : Meta }


dataDecoder : Decoder Data
dataDecoder =
    succeed Data
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


dataView : DataContext -> PageContext
dataView data =
    case data.frontmatter.data of
        BaseData base ->
            baseView base

        PostData post ->
            postView post

        UnknownData ->
            { title = "", body = Html.div [] [] }
