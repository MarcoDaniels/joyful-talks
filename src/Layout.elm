module Layout exposing (layoutView)

import Body.Type exposing (BodyData(..))
import Context exposing (Content, Element, Model)
import Element.Cookie exposing (cookieView)
import Element.Empty exposing (emptyNode)
import Element.Footer exposing (footerView)
import Element.Header exposing (headerView)
import Feed.Type exposing (Feed)
import Feed.View exposing (feedView)
import Html exposing (article, div)
import Html.Attributes exposing (id)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)
import Pages exposing (PathKey)
import Pages.PagePath exposing (PagePath)


layoutView : PagePath PathKey -> Model -> Content -> Maybe Feed -> Element
layoutView path model content maybeFeed =
    div [ id "app" ]
        [ headerView path content.settings.navigation model.menuExpand
        , article [ id "content" ]
            ([ [ case content.data of
                    BodyDataBase base ->
                        baseView base

                    BodyDataPost post ->
                        postView post

                    _ ->
                        emptyNode
               ]
             , [ case maybeFeed of
                    Just feed ->
                        feedView feed

                    Nothing ->
                        emptyNode
               ]
             ]
                |> List.concat
            )
        , cookieView model.cookieConsent content.settings.cookie
        , footerView content.settings.footer
        ]
