module Page.Base exposing (baseDecoder, baseView)

import Context exposing (PageData)
import Element.Empty exposing (emptyNode)
import Element.Feed exposing (feedView)
import Element.Hero exposing (heroView)
import Element.Image exposing (ImageType(..), imageView)
import Html exposing (div, h1, img, text)
import Html.Attributes exposing (class, src)
import Markdown exposing (markdownRender)
import OptimizedDecoder exposing (Decoder, andThen, field, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Shared.Decoder exposing (fieldDecoder, imageDecoder)
import Shared.Types exposing (Base, BaseContent, BaseContentValue(..), Feed, Field, HeroContent)


baseDecoder : Decoder Base
baseDecoder =
    succeed Base
        |> required "title" string
        |> required "description" string
        |> required "postsFeed" (maybe (list string))
        |> required "content"
            (list
                (succeed BaseContent
                    |> required "field" fieldDecoder
                    |> custom
                        (field "field" fieldDecoder
                            |> andThen
                                (\field ->
                                    case ( field.fieldType, field.label ) of
                                        ( "markdown", _ ) ->
                                            succeed BaseContentValueMarkdown |> required "value" string

                                        ( "image", _ ) ->
                                            succeed BaseContentValueImage |> required "value" imageDecoder

                                        ( "set", "Hero" ) ->
                                            succeed BaseContentValueHero
                                                |> required "value"
                                                    (succeed HeroContent
                                                        |> required "title" string
                                                        |> required "image" imageDecoder
                                                    )

                                        _ ->
                                            succeed BaseContentValueUnknown
                                )
                        )
                )
            )


baseView : Base -> Maybe Feed -> PageData
baseView base maybeFeed =
    { title = base.title
    , body =
        div []
            (List.concat
                [ base.content
                    |> List.map
                        (\content ->
                            case content.value of
                                BaseContentValueMarkdown markdown ->
                                    markdownRender markdown

                                BaseContentValueImage image ->
                                    imageView { src = image.path, alt = image.title } ImageDefault

                                BaseContentValueHero hero ->
                                    heroView hero

                                BaseContentValueUnknown ->
                                    emptyNode
                        )
                , List.singleton
                    (case maybeFeed of
                        Just feed ->
                            feedView feed

                        Nothing ->
                            emptyNode
                    )
                ]
            )
    }
