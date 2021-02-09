module Metadata exposing (..)

import Context exposing (DataContext)
import Head
import Head.Seo as Seo
import Pages exposing (images)


head : DataContext -> List (Head.Tag Pages.PathKey)
head data =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = ""
        , image =
            { url = images.iconPng
            , alt = data.frontmatter.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = data.frontmatter.description
        , locale = Nothing
        , title = data.frontmatter.title
        }
        |> Seo.website
