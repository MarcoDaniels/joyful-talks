module Content exposing (contentDecoder)

import Context exposing (Content, Data(..))
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
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
