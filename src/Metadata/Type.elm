module Metadata.Type exposing (..)

import Shared.Type exposing (Link)


type alias CookieBanner =
    { title : String, content : String }


type alias Footer =
    { links : List Link, info : String }


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


type alias Site =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Settings =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , site : Site
    }


type alias BasePageMeta =
    { title : String
    , description : String
    , feed : Maybe (List String)
    , settings : Settings
    }


type alias PostPageMeta =
    { title : String
    , description : String
    , settings : Settings
    }


type Metadata
    = MetadataBase BasePageMeta
    | MetadataPost PostPageMeta
    | MetadataUnknown


type alias PageMetadata =
    { collection : String, metadata : Metadata }
