module Body exposing (bodyView)

import Context exposing (Content, Data(..), Renderer)
import Element.Empty exposing (emptyNode)
import OptimizedDecoder exposing (Error, andThen, decodeString, field, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder, baseView)
import Page.Post exposing (postDecoder, postView)


bodyDecoder : String -> Result Error Content
bodyDecoder input =
    decodeString
        (succeed Content
            |> required "collection" string
            |> custom
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
        )
        input


bodyView : String -> Result String Renderer
bodyView cont =
    case bodyDecoder cont of
        Ok content ->
            Ok
                [ case content.data of
                    BaseData base ->
                        baseView base

                    PostData post ->
                        postView post

                    _ ->
                        emptyNode
                ]

        Err _ ->
            Ok [ emptyNode ]
