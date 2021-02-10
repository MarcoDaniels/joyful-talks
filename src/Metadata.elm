module Metadata exposing (..)

import Context exposing (DataContext)
import Head
import Head.Seo as Seo
import Pages exposing (images)


metadataHead : DataContext -> List (Head.Tag Pages.PathKey)
metadataHead dataContext =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = ""
        , image =
            { url = images.iconPng
            , alt = dataContext.frontmatter.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = dataContext.frontmatter.description
        , locale = Nothing
        , title = dataContext.frontmatter.title
        }
        |> Seo.website
