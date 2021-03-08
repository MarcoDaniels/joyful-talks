module Shared.Types exposing (..)


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


type ColumnContent
    = ColumnContentMarkdown String
    | ColumnContentAsset AssetPath
    | ColumnContentUnknown


type alias ColumnContentField =
    { field : Field, value : ColumnContent }


type BaseContentValue
    = BaseContentValueMarkdown String
    | BaseContentValueAsset AssetPath
    | BaseContentValueHero HeroContent
    | BaseContentValueColumn (List ColumnContentField)
    | BaseContentValueUnknown


type alias BaseContent =
    { field : Field, value : BaseContentValue }


type alias Base =
    { title : String
    , description : String
    , postsFeed : Maybe (List String)
    , content : List BaseContent
    }


type PostContentRepeaterType
    = PostContentRepeaterMarkdown String
    | PostContentRepeaterAsset AssetPath
    | PostContentRepeaterUnknown



-- TODO: update to use ColumnContentField


type alias PostContentRepeaterField =
    { field : Field, value : PostContentRepeaterType }


type PostContentValue
    = PostContentValueMarkdown String
    | PostContentValueAsset AssetPath
    | PostContentValueRepeater (List PostContentRepeaterField)
    | PostContentValueUnknown


type alias PostContent =
    { field : Field, value : PostContentValue }


type alias Post =
    { title : String
    , description : String
    , content : List PostContent
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
