module Layout exposing (layoutView)

import Context exposing (Element, Model, Renderer)
import Element.Cookie exposing (cookieView)
import Element.Empty exposing (emptyNode)
import Element.Footer exposing (footerView)
import Element.Header exposing (headerView)
import Feed.Type exposing (Feed)
import Feed.View exposing (feedView)
import Html exposing (article, div)
import Html.Attributes exposing (id)
import Metadata.Type exposing (Settings)
import Pages exposing (PathKey)
import Pages.PagePath exposing (PagePath)


layoutView : PagePath PathKey -> Model -> Settings -> Renderer -> Maybe Feed -> Element
layoutView path model settings renderer maybeFeed =
    div [ id "app" ]
        [ headerView path settings.navigation model.menuExpand
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
        , cookieView model.cookieConsent settings.cookie
        , footerView settings.footer
        ]
