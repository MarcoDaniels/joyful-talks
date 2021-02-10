module Data.Types exposing (..)


type alias Field =
    { fieldType : String }


type alias StandardPageContentText =
    { field : Field
    , value : String
    }


type alias ImagePath =
    { path : String }


type alias StandardPageContentImage =
    { field : Field
    , value : ImagePath
    }


type StandardPageContent
    = StandardPageText StandardPageContentText
    | StandardPageImage StandardPageContentImage
    | StandardPageEmpty


type alias StandardPage =
    { pageType : String
    , title : String
    , description : String
    , content : List StandardPageContent
    }


type PostPageContent
    = PostPageText StandardPageContentText
    | PostPageEmpty


type alias PostPage =
    { pageType : String
    , title : String
    , description : String
    , content : List PostPageContent
    }


type Data
    = DataPostPage PostPage
    | DataStandardPage StandardPage
