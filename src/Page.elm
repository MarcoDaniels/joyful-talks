module Page exposing (..)

import Json.Decode as Decode exposing (list, string)
import Json.Decode.Pipeline exposing (required)


type alias Field =
    { fieldType : String, label : String }


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
    = PageText PageTextContent
    | PageImage PageImageContent


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
        |> required "label" string


contentTxDecoder : Decode.Decoder PageTextContent
contentTxDecoder =
    Decode.succeed PageTextContent
        |> required "field" fieldTypeDecoder
        |> required "value" string


contentImDecoder : Decode.Decoder PageImageContent
contentImDecoder =
    Decode.succeed PageImageContent
        |> required "field" fieldTypeDecoder
        |> required "value"
            (Decode.succeed ImagePath
                |> required "path" string
            )


contentDecoder : Decode.Decoder PageContent
contentDecoder =
    Decode.oneOf
        [ contentTxDecoder
            |> Decode.map PageText
        , contentImDecoder
            |> Decode.map PageImage
        ]


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.succeed Page
        |> required "pageType" string
        |> required "title" string
        |> required "description" string
        |> required "content" (list contentDecoder)
