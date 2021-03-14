module Body exposing (bodyView)

import Context exposing (Renderer)
import Element.Empty exposing (emptyNode)
import OptimizedDecoder exposing (Error, andThen, decodeString, field, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder, baseView)
import Page.Post exposing (postDecoder, postView)
import Shared.Types exposing (BodyContent, BodyData(..))


bodyDecoder : String -> Result Error BodyContent
bodyDecoder input =
    decodeString
        (succeed BodyContent
            |> required "collection" string
            |> custom
                (field "collection" string
                    |> andThen
                        (\collection ->
                            case collection of
                                "joyfulPage" ->
                                    succeed BodyDataBase |> required "data" baseDecoder

                                "joyfulPost" ->
                                    succeed BodyDataPost |> required "data" postDecoder

                                _ ->
                                    succeed BodyDataUnknown
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
                    BodyDataBase base ->
                        baseView base

                    BodyDataPost post ->
                        postView post

                    _ ->
                        emptyNode
                ]

        Err _ ->
            Ok [ emptyNode ]
