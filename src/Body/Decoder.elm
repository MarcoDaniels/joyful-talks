module Body.Decoder exposing (bodyDecoder)

import Body.Type exposing (BodyData(..), ContentValue, CookieBanner, Footer, Navigation, Settings)
import Context exposing (Content)
import OptimizedDecoder exposing (Decoder, Error, andThen, decodeString, field, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder)
import Page.Post exposing (postDecoder)
import Shared.Decoder exposing (linkDecoder, linkValueDecoder)


settingsDecoder : Decoder Settings
settingsDecoder =
    succeed Settings
        |> required "navigation"
            (succeed Navigation
                |> required "brand" linkDecoder
                |> required "menu" (list linkValueDecoder)
                |> required "social" (list linkValueDecoder)
            )
        |> required "footer"
            (succeed Footer
                |> required "links" (list linkValueDecoder)
                |> required "info" string
            )
        |> required "cookie"
            (succeed CookieBanner
                |> required "title" string
                |> required "content" string
            )


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
                                    succeed BodyDataBase
                                        |> required "data" baseDecoder

                                "joyfulPost" ->
                                    succeed BodyDataPost
                                        |> required "data" postDecoder

                                _ ->
                                    succeed BodyDataUnknown
                        )
                )
            |> required "settings" settingsDecoder
        )
        input
