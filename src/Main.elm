port module Main exposing (main)

import Body.View exposing (bodyView)
import Context exposing (CookieConsent, CookieMsg(..), MetadataContext, Model, Msg(..), Renderer, StaticRequest)
import Element.Empty exposing (emptyNode)
import Feed.Request exposing (requestFeed)
import Generate.Rss exposing (generateRss)
import Layout exposing (layoutView)
import Manifest exposing (manifest)
import Metadata.Decoder exposing (metadataDecoder)
import Metadata.Type exposing (Metadata(..), PageMetadata)
import OptimizedDecoder exposing (decoder)
import Pages exposing (PathKey, internals)
import Pages.Platform exposing (Program)
import Pages.StaticHttp as StaticHttp
import SEO exposing (headSEO)


main : Pages.Platform.Program Model Msg PageMetadata Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = \_ -> view
        , update = updateWithPort
        , subscriptions = \_ _ _ -> subscriptions
        , documents =
            [ { extension = "md"
              , metadata = decoder metadataDecoder
              , body = bodyView
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.withFileGenerator generateRss
        |> Pages.Platform.toProgram


init : ( Model, Cmd Msg )
init =
    ( { cookieConsent = { accept = True }, menuExpand = False }, Cmd.none )


port cookieState : (CookieConsent -> msg) -> Sub msg


port cookieAccept : CookieConsent -> Cmd msg


updateWithPort : Msg -> Model -> ( Model, Cmd Msg )
updateWithPort msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
    ( newModel, Cmd.batch [ cookieAccept newModel.cookieConsent, cmd ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Cookie consent ->
            case consent of
                CookieState state ->
                    ( { model | cookieConsent = state }, Cmd.none )

                CookieAccept ->
                    ( { model | cookieConsent = { accept = True } }, Cmd.none )

        MenuExpand expand ->
            ( { model | menuExpand = expand }, Cmd.none )

        NoOp _ ->
            ( model, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    Sub.batch [ Sub.map Cookie (cookieState CookieState) ]


view : MetadataContext -> StaticHttp.Request StaticRequest
view metadataContext =
    case metadataContext.frontmatter.metadata of
        MetadataBase base ->
            case base.feed of
                Just filterFeed ->
                    requestFeed filterFeed
                        |> StaticHttp.map
                            (\feed ->
                                { view =
                                    \model renderedBody ->
                                        { title = base.title
                                        , body = layoutView metadataContext.path model base.settings renderedBody (Just feed)
                                        }
                                , head = headSEO base.title base.description
                                }
                            )

                Nothing ->
                    StaticHttp.succeed
                        { view =
                            \model renderedBody ->
                                { title = base.title
                                , body = layoutView metadataContext.path model base.settings renderedBody Nothing
                                }
                        , head = headSEO base.title base.description
                        }

        MetadataPost post ->
            StaticHttp.succeed
                { view =
                    \model renderedBody ->
                        { title = post.title
                        , body = layoutView metadataContext.path model post.settings renderedBody Nothing
                        }
                , head = headSEO post.title post.description
                }

        MetadataUnknown ->
            StaticHttp.succeed { view = \_ _ -> { title = "", body = emptyNode }, head = [] }
