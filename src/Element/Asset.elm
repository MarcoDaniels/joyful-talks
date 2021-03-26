module Element.Asset exposing (AssetDefaultType(..), AssetType(..), assetView)

import Context exposing (Element)
import Html exposing (img, node, source)
import Html.Attributes exposing (alt, attribute, class, media, src)


type alias DeviceSizes =
    { s : Int, m : Int, l : Int, xl : Int }


type AssetDefaultType
    = AssetDefaultLandscape
    | AssetDefaultPortrait


type AssetType
    = AssetFeed
    | AssetHero
    | AssetRow Int
    | AssetRelated
    | AssetDefault AssetDefaultType


type alias Asset =
    { src : String, alt : String }


assetView : Asset -> AssetType -> Element
assetView asset assetType =
    case assetType of
        AssetFeed ->
            imageWithSizes asset { s = 500, m = 300, l = 400, xl = 400 } Nothing

        AssetDefault postType ->
            case postType of
                AssetDefaultPortrait ->
                    imageWithSizes asset { s = 500, m = 700, l = 600, xl = 900 } (Just "img-portrait")

                AssetDefaultLandscape ->
                    imageWithSizes asset { s = 500, m = 700, l = 900, xl = 1200 } Nothing

        AssetHero ->
            imageWithSizes asset { s = 500, m = 700, l = 900, xl = 1200 } Nothing

        AssetRow count ->
            imageWithSizes asset { s = 500, m = 700, l = 1000 // count, xl = 1200 // count } Nothing

        AssetRelated ->
            imageWithSizes asset { s = 500, m = 700, l = 300, xl = 350 } Nothing


imageWithSizes : Asset -> DeviceSizes -> Maybe String -> Element
imageWithSizes asset sizes className =
    node "picture"
        [ class (Maybe.withDefault "" className) ]
        [ source
            [ media "(max-width: 550px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI asset.src (Just sizes.s))
            ]
            []
        , source
            [ media "(max-width: 750px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI asset.src (Just sizes.m))
            ]
            []
        , source
            [ media "(max-width: 1000px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI asset.src (Just sizes.l))
            ]
            []
        , source
            [ media "(max-width: 1200px), (min-width: 1200px)"
            , attribute "sizes" "90vw"
            , attribute "srcset" (imageAPI asset.src (Just sizes.xl))
            ]
            []
        , img [ src (imageAPI asset.src Nothing), alt asset.alt, attribute "loading" "lazy" ] []
        ]


imageAPI : String -> Maybe Int -> String
imageAPI src maybeDevice =
    case maybeDevice of
        Just device ->
            "/image/api" ++ src ++ "?w=" ++ String.fromInt device ++ "&o=1&q=60 " ++ String.fromInt device ++ "w"

        Nothing ->
            "/image/api" ++ src ++ "?w=1200&o=1&q=60"
