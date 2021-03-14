module Feed.Type exposing (..)

import Shared.Type exposing (AssetPath)


type alias FeedItem =
    { title : String
    , description : String
    , url : String
    , asset : AssetPath
    }


type alias Feed =
    { entries : List FeedItem }
