module SEO exposing (headSEO)

import Head
import Head.Seo as Seo
import Pages exposing (images)
import Shared.Type exposing (SiteSettings)


headSEO : ( String, String ) -> SiteSettings -> List (Head.Tag Pages.PathKey)
headSEO ( title, description ) settings =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = settings.title
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
