module Data exposing (Data, DataContent(..), DataContext, dataDecoder, dataView)

import Context exposing (PageContext)
import Shared.Types exposing (Base, Post)
import Html
import Json.Decode exposing (Decoder, andThen, field, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Pages
import Pages.Base exposing (baseDecoder, baseView)
import Pages.PagePath exposing (PagePath)
import Pages.Post exposing (postDecoder, postView)


type alias DataContext =
    { path : PagePath Pages.PathKey
    , frontmatter : Data
    }

type DataContent
    = BaseData Base
    | PostData Post
    | UnknownData


type alias Data =
    { pageType : String, data : DataContent }


dataDecoder : Decoder Data
dataDecoder =
    succeed Data
        |> required "pageType" string
        |> custom
            (field "pageType" string
                |> andThen
                    (\pageType ->
                        case pageType of
                            "base" ->
                                succeed BaseData |> required "data" baseDecoder

                            "post" ->
                                succeed PostData |> required "data" postDecoder

                            _ ->
                                succeed UnknownData
                    )
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
