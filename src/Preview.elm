port module Preview exposing (main)

import Body.Type exposing (BodyData(..))
import Browser
import Context exposing (Element, Msg(..))
import Html exposing (div, text)
import Html.Attributes exposing (id)
import OptimizedDecoder exposing (Error, andThen, decodeString, field, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, required)
import Page.Base exposing (baseDecoder, baseView)
import Page.Post exposing (postDecoder, postView)


main : Program () PreviewModel Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port updatePayload : (String -> msg) -> Sub msg


type alias PreviewModel =
    { collection : String, data : BodyData }


init : () -> ( PreviewModel, Cmd Msg )
init _ =
    ( { collection = "noContext", data = BodyDataUnknown }, Cmd.none )


payloadDecoder : String -> Result Error PreviewModel
payloadDecoder input =
    decodeString
        (succeed PreviewModel
            |> required "collection" string
            |> custom
                (field "collection" string
                    |> andThen
                        (\collection ->
                            case collection of
                                "joyfulPage" ->
                                    succeed BodyDataBase
                                        |> required "data" baseDecoder

                                "joyfulPost" ->
                                    succeed BodyDataPost
                                        |> required "data" postDecoder

                                _ ->
                                    succeed BodyDataUnknown
                        )
                )
        )
        input


update : Msg -> PreviewModel -> ( PreviewModel, Cmd Msg )
update msg model =
    case msg of
        OnPreviewUpdate payload ->
            ( case payloadDecoder payload of
                Ok content ->
                    content

                Err _ ->
                    { collection = "noContext", data = BodyDataUnknown }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


subscriptions : PreviewModel -> Sub Msg
subscriptions _ =
    updatePayload OnPreviewUpdate


view : PreviewModel -> Element
view { data } =
    div [ id "app" ]
        [ case data of
            BodyDataBase base ->
                baseView base

            BodyDataPost post ->
                postView post

            _ ->
                text "TODO: display err"
        ]
