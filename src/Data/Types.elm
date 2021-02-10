module Data.Types exposing (..)


type alias Field =
    { fieldType : String }


type alias BaseContentTextField =
    { field : Field
    , value : String
    }


type alias ImagePath =
    { path : String }


type alias BaseContentImageField =
    { field : Field
    , value : ImagePath
    }


type BaseContent
    = BaseContentText BaseContentTextField
    | BaseContentImage BaseContentImageField
    | BaseContentEmpty


type alias Base =
    { pageType : String
    , title : String
    , description : String
    , content : List BaseContent
    }


type PostContent
    = PostContentText BaseContentTextField
    | PostContentEmpty


type alias Post =
    { pageType : String
    , title : String
    , description : String
    , content : List PostContent
    }


type Data
    = DataPost Post
    | DataBase Base
