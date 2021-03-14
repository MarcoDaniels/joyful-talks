module Shared.Type exposing (..)


type alias Field =
    { fieldType : String, label : String }


type alias AssetPath =
    { path : String
    , title : String
    , width : Int
    , height : Int
    , colors : Maybe (List String)
    }


type alias Link =
    { text : String, url : String }
