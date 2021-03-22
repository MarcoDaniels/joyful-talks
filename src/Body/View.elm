module Body.View exposing (bodyView)

import Body.Type exposing (BodyData(..))
import Context exposing (Content, Element)
import Element.Empty exposing (emptyNode)
import Feed.Type exposing (Feed)
import Feed.View exposing (feedView)
import Html exposing (article)
import Html.Attributes exposing (id)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)


bodyView : BodyData -> Maybe Feed -> Element
bodyView data maybeFeed =
    article [ id "content" ]
        ([ [ case data of
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
