module Layout exposing (layoutView)

import Context exposing (MetadataContext, Model, Msg(..), Layout, Renderer)
import Element.Cookie exposing (cookieView)
import Element.Empty exposing (emptyNode)
import Element.Feed exposing (feedView)
import Element.Footer exposing (footerView)
import Element.Header exposing (headerView)
import Html exposing (article, div)
import Html.Attributes exposing (id)
import Shared.Types exposing (Feed)


layoutView : Renderer -> MetadataContext -> Model -> Maybe Feed -> Layout
layoutView renderer context model maybeFeed =
    { title = context.frontmatter.seo.title
    , body =
        div [ id "app" ]
            [ headerView context model.menuExpand
            , article [ id "content" ]
                (List.concat
                    [ renderer
                    , List.singleton
                        (case maybeFeed of
                            Just feed ->
                                feedView feed

                            Nothing ->
                                emptyNode
                        )
                    ]
                )
            , cookieView model.cookieConsent context.frontmatter.meta.cookie
            , footerView context.frontmatter.meta.footer
            ]
    }
