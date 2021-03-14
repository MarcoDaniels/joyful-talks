module SEO exposing (headSEO)

import Head
import Head.Seo as Seo
import Pages exposing (images)


headSEO : String -> String -> List (Head.Tag Pages.PathKey)
headSEO title description =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = ""
        , image =
            { url = images.iconPng
            , alt = title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = description
        , locale = Nothing
        , title = title
        }
        |> Seo.website
