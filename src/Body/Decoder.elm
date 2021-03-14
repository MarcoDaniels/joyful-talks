module Body.Decoder exposing (bodyDecoder)

import Body.Type exposing (BodyData(..), PageBody)
import OptimizedDecoder exposing (Error, andThen, decodeString, field, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)


bodyDecoder : String -> Result Error PageBody
bodyDecoder input =
    decodeString
        (succeed PageBody
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
