module SEO exposing (headSEO)

import Head
import Head.Seo as Seo
import Pages exposing (images)
import Shared.Types exposing (SEO)


headSEO : SEO -> List (Head.Tag Pages.PathKey)
headSEO seo =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = ""
        , image =
            { url = images.iconPng
            , alt = seo.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = seo.description
        , locale = Nothing
        , title = seo.title
        }
        |> Seo.website
