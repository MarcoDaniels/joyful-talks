module Data.Types exposing (..)


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
    { pageType : String
    , title : String
    , description : String
    , content : List BaseContent
    }
