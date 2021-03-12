port module Main exposing (main)

import Body exposing (bodyView)
import ContentFeed exposing (contentFeed)
import Context exposing (Content, CookieConsent, CookieMsg(..), Data(..), Metadata, MetadataContext, Model, Msg(..), PageData, Renderer, StaticRequest)
import Layout exposing (layoutView)
import Manifest exposing (manifest)
import Metadata exposing (metadataDecoder)
import OptimizedDecoder exposing (decoder)
import Pages exposing (PathKey, internals)
import Pages.Platform exposing (Program)
import Pages.StaticHttp as StaticHttp
import SEO exposing (headSEO)


main : Pages.Platform.Program Model Msg Metadata Renderer Pages.PathKey
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
        |> Pages.Platform.toProgram


init : ( Model, Cmd Msg )
init =
    ( { cookieConsent = { accept = True }, menuExpand = False }
    , Cmd.none
    )


port cookieState : (CookieConsent -> msg) -> Sub msg


port cookieAccept : CookieConsent -> Cmd msg


updateWithPort : Msg -> Model -> ( Model, Cmd Msg )
updateWithPort msg model =
    let
        ( newModel, cmd ) =
            update msg model
    in
    ( newModel
    , Cmd.batch [ cookieAccept newModel.cookieConsent, cmd ]
    )


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
    case metadataContext.frontmatter.feed of
        Just filterFeed ->
            contentFeed filterFeed
                |> StaticHttp.map
                    (\feed ->
                        { view = \model body -> layoutView body metadataContext model (Just feed)
                        , head = headSEO metadataContext.frontmatter.seo
                        }
                    )

        Nothing ->
            StaticHttp.succeed
                { view = \model body -> layoutView body metadataContext model Nothing
                , head = headSEO metadataContext.frontmatter.seo
                }
