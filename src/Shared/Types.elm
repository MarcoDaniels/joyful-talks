module Shared.Types exposing (..)


type alias Field =
    { fieldType : String }


type alias ImagePath =
    { path : String }


type BaseContentValue
    = BaseContentValueText String
    | BaseContentValueMarkdown String
    | BaseContentValueImage ImagePath
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
    | PostContentRepeaterImage ImagePath
    | PostContentRepeaterUnknown


type alias PostContentRepeaterField =
    { field : Field, value : PostContentRepeaterType }


type PostContentValue
    = PostContentValueMarkdown String
    | PostContentValueImage ImagePath
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
    { brand: Link, menu : List Link, social : List Link }


type alias Meta =
    { navigation : Navigation, footer : Footer, cookie : CookieBanner }


type alias FeedItem =
    { title : String, description : String, url : String, image : ImagePath }


type alias Feed =
    { entries : List FeedItem }
