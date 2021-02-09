module PageExample exposing (..)


type alias PageSEO =
    { title : String, description : String }


type alias PageSettings =
    { pageType : String }


type alias PageTextContent =
    { field : { fieldType : String, label : String }
    , value : String
    }


type alias PageImageContent =
    { field : { fieldType : String, label : String }
    , value : { path : String }
    }


type PageContent
    = PageText PageTextContent
    | PageImage PageImageContent


type alias Page =
    { settings : PageSettings
    , seo : PageSEO
    , content : List PageContent
    }


u : Page
u =
    { seo =
        { title = ""
        , description = ""
        }
    , settings = { pageType = "" }
    , content =
        [ PageText { field = { fieldType = "", label = "" }, value = "" }
        , PageImage { field = { fieldType = "", label = "" }, value = { path = "" } }
        ]
    }


t : Page -> List String
t page =
    List.map
        (\content ->
            case content of
                PageText { field, value } ->
                    value

                PageImage { field, value } ->
                    value.path
        )
        page.content
