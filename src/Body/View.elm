module Body.View exposing (bodyView)

import Body.Decoder exposing (bodyDecoder)
import Body.Type exposing (BodyData(..))
import Context exposing (Renderer)
import Element.Empty exposing (emptyNode)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)


bodyView : String -> Result String Renderer
bodyView cont =
    case bodyDecoder cont of
        Ok content ->
            Ok
                [ case content.data of
                    BodyDataBase base ->
                        baseView base

                    BodyDataPost post ->
                        postView post

                    _ ->
                        emptyNode
                ]

        Err _ ->
            Ok [ emptyNode ]
