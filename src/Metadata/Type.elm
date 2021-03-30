module Metadata.Type exposing (..)


type alias BasePageMeta =
    { title : String
    , description : String
    , image : Maybe String
    , feed : Maybe (List String)
    }


type alias PostPageMeta =
    { title : String
    , description : String
    , image : Maybe String
    }


type Metadata
    = MetadataBase BasePageMeta
    | MetadataPost PostPageMeta
    | MetadataUnknown


type alias PageMetadata =
    { collection : String, metadata : Metadata }
