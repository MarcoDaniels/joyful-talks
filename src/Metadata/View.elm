module Metadata.View exposing (baseViewMeta, postViewMeta)

import Body.View exposing (bodyView)
import Context exposing (MetadataContext, StaticRequest)
import Feed.Type exposing (Feed)
import Layout exposing (layoutView)
import Metadata.Type exposing (BasePageMeta, PostPageMeta)
import SEO exposing (SEO, headSEO)
import Settings exposing (settings)


baseViewMeta : MetadataContext -> BasePageMeta -> Maybe Feed -> StaticRequest
baseViewMeta meta base maybeFeed =
    { view =
        \model { data, settings } ->
            { title = base.title
            , body =
                maybeFeed
                    |> bodyView data
                    |> layoutView meta.path model settings
            }
    , head =
        headSEO
            { title = base.title
            , description = base.description
            , image = base.image
            }
            meta.path
    }


postViewMeta : MetadataContext -> PostPageMeta -> StaticRequest
postViewMeta meta post =
    let
        buildTitle =
            settings.titlePrefix ++ post.title
    in
    { view =
        \model { data, settings } ->
            { title = buildTitle
            , body =
                Nothing
                    |> bodyView data
                    |> layoutView meta.path model settings
            }
    , head =
        headSEO
            { title = buildTitle
            , description = post.description
            , image = post.image
            }
            meta.path
    }
