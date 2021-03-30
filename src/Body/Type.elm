module Body.Type exposing (..)

import Settings exposing (SiteSettings)
import Shared.Type exposing (AssetPath, Field, Link)
import Time exposing (Posix)


type alias HeroContent =
    { asset : AssetPath, text : Maybe String }


type RowContentValue
    = RowContentMarkdown String
    | RowContentAsset AssetPath
    | RowContentUnknown


type alias RowContentField =
    { field : Field, value : RowContentValue }


type alias IframeContentField =
    { source : String, title : String, ratio : String }


type ContentValue
    = ContentValueMarkdown String
    | ContentValueAsset AssetPath
    | ContentValueHero HeroContent
    | ContentValueRow (List RowContentField)
    | ContentValueIframe IframeContentField
    | ContentValueUnknown


type alias ContentFieldValue =
    { field : Field, value : ContentValue }


type alias BasePage =
    { title : String
    , description : String
    , url : String
    , postsFeed : Maybe (List String)
    , content : Maybe (List ContentFieldValue)
    }


type alias Written =
    { name : String, url : Maybe String }


type alias RelatedItem =
    { title : String
    , url : String
    , asset : AssetPath
    }


type alias PostPage =
    { title : String
    , description : String
    , url : String
    , asset : Maybe AssetPath
    , content : Maybe (List ContentFieldValue)
    , written : Written
    , published : Maybe Posix
    , related : Maybe (List RelatedItem)
    }


type BodyData
    = BodyDataBase BasePage
    | BodyDataPost PostPage
    | BodyDataUnknown


type alias CookieBanner =
    { title : String, content : String }


type alias Footer =
    { links : List Link, info : String }


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


type alias Settings =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , site : SiteSettings
    }
