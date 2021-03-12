module Body exposing (..)

import Content exposing (contentDecoder)
import Context exposing (Content, Data(..), Renderer)
import Element.Empty exposing (emptyNode)
import OptimizedDecoder exposing (Error, decodeString)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)


bodyDecoder : String -> Result Error Content
bodyDecoder input =
    decodeString contentDecoder input


bodyView : String -> Result String Renderer
bodyView cont =
    case bodyDecoder cont of
        Ok content ->
            Ok
                [ case content.content of
                    BaseData base ->
                        baseView base

                    PostData post ->
                        postView post

                    _ ->
                        emptyNode
                ]

        Err _ ->
            Ok [ emptyNode ]
