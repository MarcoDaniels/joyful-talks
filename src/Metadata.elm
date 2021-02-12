module Metadata exposing (..)

import Content exposing (ContentContext, Data(..))
import Head
import Head.Seo as Seo
import Pages exposing (images)


type alias SEO =
    { title : String, description : String }


seoSummary : SEO -> List (Head.Tag Pages.PathKey)
seoSummary seo =
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


metadataHead : ContentContext -> List (Head.Tag Pages.PathKey)
metadataHead { frontmatter } =
    case frontmatter.data of
        BaseData base ->
            seoSummary { title = base.title, description = base.description }

        PostData post ->
            seoSummary { title = post.title, description = post.description }

        UnknownData ->
            []
