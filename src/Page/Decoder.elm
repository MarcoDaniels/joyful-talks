module Page.Decoder exposing (..)

import Json.Decode as Decode exposing (list, string)
import Json.Decode.Pipeline exposing (required)


type alias Field =
    { fieldType : String }


type alias PageTextContent =
    { field : Field
    , value : String
    }


type alias ImagePath =
    { path : String }


type alias PageImageContent =
    { field : Field
    , value : ImagePath
    }


type PageContent
    = TextContent PageTextContent
    | ImageContent PageImageContent
    | EmptyContent


type alias Page =
    { pageType : String
    , title : String
    , description : String
    , content : List PageContent
    }


fieldTypeDecoder : Decode.Decoder Field
fieldTypeDecoder =
    Decode.succeed Field
        |> required "type" string


contentTextDecoder : Decode.Decoder PageTextContent
contentTextDecoder =
    Decode.succeed PageTextContent
        |> required "field" fieldTypeDecoder
        |> required "value" string


contentImageDecoder : Decode.Decoder PageImageContent
contentImageDecoder =
    Decode.succeed PageImageContent
        |> required "field" fieldTypeDecoder
        |> required "value"
            (Decode.succeed ImagePath
                |> required "path" string
            )


contentDecoder : Decode.Decoder PageContent
contentDecoder =
    Decode.oneOf
        [ contentTextDecoder
            |> Decode.map TextContent
        , contentImageDecoder
            |> Decode.map ImageContent
        , Decode.succeed EmptyContent
        ]


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.succeed Page
        |> required "pageType" string
        |> required "title" string
        |> required "description" string
        |> required "content" (list contentDecoder)