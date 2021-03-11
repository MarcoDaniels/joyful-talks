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


type BaseContentValue
    = BaseContentValueMarkdown String
    | BaseContentValueAsset AssetPath
    | BaseContentValueHero HeroContent
    | BaseContentValueRow (List RowContentField)
    | BaseContentValueUnknown


type alias BaseContent =
    { field : Field, value : BaseContentValue }


type alias Base =
    { title : String
    , description : String
    , postsFeed : Maybe (List String)
    , content : List BaseContent
    }


type PostContentValue
    = PostContentValueMarkdown String
    | PostContentValueAsset AssetPath
    | PostContentValueRow (List RowContentField)
    | PostContentValueUnknown


type alias PostContent =
    { field : Field, value : PostContentValue }


type alias Written =
    { name : String, url : Maybe String }


type alias RelatedItem =
    { title : String
    , url : String
    , asset : AssetPath
    }


type alias Post =
    { title : String
    , description : String
    , content : List PostContent
    , written : Written
    , updated : Posix
    , related : Maybe (List RelatedItem)
    }


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


type alias FeedItem =
    { title : String
    , description : String
    , url : String
    , asset : AssetPath
    }


type alias Feed =
    { entries : List FeedItem }
