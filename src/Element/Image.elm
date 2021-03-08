module Element.Image exposing (ImageType(..), imageView)

import Context exposing (Element)
import Html exposing (img, node, source)
import Html.Attributes exposing (alt, attribute, media, src)


type alias DeviceSizes =
    { s : String, m : String, l : String, xl : String }


type ImageType
    = ImageFeed
    | ImagePost
    | ImageHero
    | ImageDefault


type alias Image =
    { src : String, alt : String }


imageView : Image -> ImageType -> Element
imageView image imageType =
    case imageType of
        ImageFeed ->
            imageWithSizes image { s = "500", m = "300", l = "400", xl = "400" }

        ImagePost ->
            imageWithSizes image { s = "500", m = "700", l = "900", xl = "1200" }

        ImageHero ->
            imageWithSizes image { s = "500", m = "700", l = "900", xl = "1200" }

        ImageDefault ->
            imageWithSizes image { s = "550", m = "750", l = "1000", xl = "1200" }


imageWithSizes : Image -> DeviceSizes -> Element
imageWithSizes image sizes =
    node "picture"
        []
        [ source
            [ media "(max-width: 550px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI image.src (Just sizes.s))
            ]
            []
        , source
            [ media "(max-width: 750px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI image.src (Just sizes.m))
            ]
            []
        , source
            [ media "(max-width: 1000px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI image.src (Just sizes.l))
            ]
            []
        , source
            [ media "(max-width: 1200px), (min-width: 1200px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI image.src (Just sizes.xl))
            ]
            []
        , img [ src (imageAPI image.src Nothing), alt image.alt, attribute "loading" "lazy" ] []
        ]


imageAPI : String -> Maybe String -> String
imageAPI src maybeDevice =
    case maybeDevice of
        Just device ->
            "/image/api" ++ src ++ "?w=" ++ device ++ "&o=1&q=60 " ++ device ++ "w"

        Nothing ->
            "/image/api" ++ src ++ "?w=1200&o=1&q=60"
