module SEO exposing (SEO, headSEO)

import Head
import Head.Seo as Seo
import Image exposing (imageAPI)
import Pages exposing (images)
import Pages.ImagePath as ImagePath
import Pages.PagePath exposing (PagePath)
import Settings exposing (settings)


type alias SEO =
    { title : String
    , description : String
    , image : Maybe String
    }


headSEO : SEO -> PagePath Pages.PathKey -> List (Head.Tag Pages.PathKey)
headSEO { title, description, image } path =
    Seo.summary
        { canonicalUrlOverride = Just path
        , siteName = settings.title
        , image =
            { url =
                case image of
                    Just img ->
                        ImagePath.external (settings.baseURL ++ imageAPI img Nothing)

                    Nothing ->
                        images.iconPng
            , alt = title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = description
        , locale = Nothing
        , title = title
        }
        |> Seo.website
