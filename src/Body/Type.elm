module Body.Type exposing (..)

import Shared.Type exposing (AssetPath, Field)
import Time exposing (Posix)


type alias HeroContent =
    { title : String, asset : AssetPath }


type RowContentValue
    = RowContentMarkdown String
    | RowContentAsset AssetPath
    | RowContentUnknown


type alias RowContentField =
    { field : Field, value : RowContentValue }


type ContentValue
    = ContentValueMarkdown String
    | ContentValueAsset AssetPath
    | ContentValueHero HeroContent
    | ContentValueRow (List RowContentField)
    | ContentValueUnknown


type alias ContentFieldValue =
    { field : Field, value : ContentValue }


type alias BasePage =
    { title : String
    , description : String
    , postsFeed : Maybe (List String)
    , content : List ContentFieldValue
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
    , asset : AssetPath
    , content : List ContentFieldValue
    , written : Written
    , updated : Posix
    , related : Maybe (List RelatedItem)
    }


type BodyData
    = BodyDataBase BasePage
    | BodyDataPost PostPage
    | BodyDataUnknown


type alias PageBody =
    { collection : String, data : BodyData }
