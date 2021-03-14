module Shared.Types exposing (..)

import Time exposing (Posix)


type alias Field =
    { fieldType : String, label : String }


type alias AssetPath =
    { path : String
    , title : String
    , width : Int
    , height : Int
    , colors : Maybe (List String)
    }


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


type alias BodyContent =
    { collection : String, data : BodyData }


type alias Link =
    { text : String, url : String }


type alias CookieBanner =
    { title : String, content : String }


type alias Footer =
    { links : List Link, info : String }


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


type alias Meta =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    }


type alias SEO =
    { title : String
    , description : String
    }


type alias FeedItem =
    { title : String
    , description : String
    , url : String
    , asset : AssetPath
    }


type alias Feed =
    { entries : List FeedItem }
