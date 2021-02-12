module Pages.Base exposing (baseDecoder, baseView)

import Context exposing (PageContext)
import Shared.Types exposing (Base, BaseContent, BaseContentValue(..), Field)
import Html
import Html.Attributes
import Json.Decode exposing (Decoder, andThen, field, list, string, succeed)
import Json.Decode.Pipeline exposing (custom, required)
import Markdown exposing (markdownRender)
import Shared.Decoder exposing (fieldDecoder, imageDecoder)


baseDecoder : Decoder Base
baseDecoder =
    succeed Base
        |> required "title" string
        |> required "description" string
        |> required "content"
            (list
                (succeed BaseContent
                    |> required "field" fieldDecoder
                    |> custom
                        (field "field" fieldDecoder
                            |> andThen
                                (\field ->
                                    case field.fieldType of
                                        "text" ->
                                            succeed BaseContentValueText |> required "value" string

                                        "markdown" ->
                                            succeed BaseContentValueMarkdown |> required "value" string

                                        "image" ->
                                            succeed BaseContentValueImage |> required "value" imageDecoder

                                        _ ->
                                            succeed BaseContentValueUnknown
                                )
                        )
                )
            )


baseView : Base -> PageContext
baseView base =
    { title = base.title
    , body =
        Html.div [ Html.Attributes.class "center" ]
            (base.content
                |> List.map
                    (\content ->
                        case content.value of
                            BaseContentValueMarkdown markdown ->
                                markdownRender markdown

                            BaseContentValueText text ->
                                Html.text text

                            BaseContentValueImage image ->
                                Html.img [ Html.Attributes.src image.path ] []

                            BaseContentValueUnknown ->
                                Html.div [] []
                    )
            )
    }
