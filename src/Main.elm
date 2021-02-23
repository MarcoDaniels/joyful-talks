port module Main exposing (main)

import Content exposing (contentDecoder, contentFeed)
import Context exposing (Content, ContentContext, CookieConsent, Data(..), Model, Msg(..), PageData, Renderer, StaticRequest)
import Html exposing (Html)
import Layout
import Manifest exposing (manifest)
import Metadata exposing (metadataHead)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)
import Pages exposing (internals)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Task
import Time


main : Pages.Platform.Program Model Msg Content Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = \_ -> view
        , update = updateWithStorage
        , subscriptions = \_ _ _ -> subscriptions
        , documents =
            [ { extension = "md"
              , metadata = contentDecoder
              , body = \_ -> Ok (Html.div [] [] |> List.singleton)
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.toProgram


init : ( Model, Cmd Msg )
init =
    ( { cookieConsent = { accept = False, date = Nothing } }
    , Cmd.none
    )


port cookieState : (Model -> msg) -> Sub msg


port cookieAccept : Model -> Cmd msg


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
    ( newModel
    , Cmd.batch [ cookieAccept newModel, cmd ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CookieState state ->
            ( { model | cookieConsent = state.cookieConsent }, Cmd.none )

        CookieAccept ->
            ( { model | cookieConsent = { accept = True, date = Just 1 } }, Cmd.none )

        NoOp _ ->
            ( model, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    cookieState CookieState


view :
    ContentContext
    -> StaticHttp.Request StaticRequest
view contentContext =
    case contentContext.frontmatter.data of
        BaseData baseData ->
            case baseData.postsFeed of
                Just filterFeed ->
                    contentFeed filterFeed
                        |> StaticHttp.map
                            (\feed ->
                                { view = \model _ -> Layout.view (baseView baseData (Just feed)) contentContext model
                                , head = metadataHead { title = baseData.title, description = baseData.description }
                                }
                            )

                Nothing ->
                    StaticHttp.succeed
                        { view = \model _ -> Layout.view (baseView baseData Nothing) contentContext model
                        , head = metadataHead { title = baseData.title, description = baseData.description }
                        }

        PostData postData ->
            StaticHttp.succeed
                { view = \model _ -> Layout.view (postView postData) contentContext model
                , head = metadataHead { title = postData.title, description = postData.description }
                }

        UnknownData ->
            StaticHttp.succeed
                { view = \model _ -> Layout.view { title = "", body = Html.div [] [] } contentContext model
                , head = []
                }
