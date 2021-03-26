port module Main exposing (main)

import Body.Decoder exposing (bodyDecoder)
import Body.View exposing (bodyView)
import Context exposing (Content, CookieConsent, CookieMsg(..), MetadataContext, Model, Msg(..), StaticRequest)
import Element.Empty exposing (emptyNode)
import Feed.Request exposing (requestFeed)
import Generate.Robots exposing (robots)
import Generate.Rss exposing (rss)
import Generate.Sitemap exposing (sitemap)
import Layout exposing (layoutView)
import Manifest exposing (manifest)
import Metadata.Decoder exposing (metadataDecoder)
import Metadata.Type exposing (Metadata(..), PageMetadata)
import OptimizedDecoder exposing (decoder, errorToString)
import Pages exposing (PathKey, internals)
import Pages.Platform exposing (Builder, Program)
import Pages.StaticHttp as StaticHttp
import SEO exposing (headSEO)


main : Pages.Platform.Program Model Msg PageMetadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = \_ -> view
        , update = updateWithPort
        , subscriptions = \_ _ _ -> subscriptions
        , documents =
            [ { extension = "md"
              , metadata = decoder metadataDecoder
              , body =
                    \body ->
                        case bodyDecoder body of
                            Ok content ->
                                Ok content

                            Err error ->
                                Err (errorToString error)
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.withFileGenerator
            (\metadata ->
                StaticHttp.succeed
                    [ Ok { path = [ "rss.xml" ], content = rss metadata }
                    , Ok { path = [ "sitemap.xml" ], content = sitemap metadata }
                    , Ok { path = [ "robots.txt" ], content = robots metadata }
                    ]
            )
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
view { frontmatter, path } =
    case frontmatter.metadata of
        MetadataBase base ->
            case base.feed of
                Just filterFeed ->
                    requestFeed filterFeed
                        |> StaticHttp.map
                            (\feed ->
                                { view =
                                    \model { data, settings } ->
                                        { title = base.title
                                        , body =
                                            Just feed
                                                |> bodyView data
                                                |> layoutView path model settings
                                        }
                                , head = headSEO ( base.title, base.description ) frontmatter.site
                                }
                            )

                Nothing ->
                    StaticHttp.succeed
                        { view =
                            \model { data, settings } ->
                                { title = base.title
                                , body =
                                    Nothing
                                        |> bodyView data
                                        |> layoutView path model settings
                                }
                        , head = headSEO ( base.title, base.description ) frontmatter.site
                        }

        MetadataPost post ->
            let
                buildTitle =
                    frontmatter.site.titlePrefix ++ post.title
            in
            StaticHttp.succeed
                { view =
                    \model { data, settings } ->
                        { title = buildTitle
                        , body =
                            Nothing
                                |> bodyView data
                                |> layoutView path model settings
                        }
                , head = headSEO ( buildTitle, post.description ) frontmatter.site
                }

        MetadataUnknown ->
            StaticHttp.succeed { view = \_ _ -> { title = "", body = emptyNode }, head = [] }
