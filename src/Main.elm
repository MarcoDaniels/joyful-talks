port module Main exposing (main)

import Body.Decoder exposing (bodyDecoder)
import Context exposing (Content, CookieConsent, CookieMsg(..), MetadataContext, Model, Msg(..), StaticRequest)
import Element.Empty exposing (emptyNode)
import Feed.Request exposing (requestFeed)
import Generate.Robots exposing (robots)
import Generate.Rss exposing (rss)
import Generate.Sitemap exposing (sitemap)
import Manifest exposing (manifest)
import Metadata.Decoder exposing (metadataDecoder)
import Metadata.Type exposing (Metadata(..), PageMetadata)
import Metadata.View exposing (baseViewMeta, postViewMeta)
import OptimizedDecoder exposing (decoder, errorToString)
import Pages exposing (PathKey, internals)
import Pages.PagePath as PagePath
import Pages.Platform exposing (Builder, Program)
import Pages.StaticHttp as StaticHttp


main : Pages.Platform.Program Model Msg PageMetadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = \_ -> view
        , update = update
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
        , onPageChange = Just OnPageChange
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


port pageChange : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Cookie consent ->
            case consent of
                CookieState state ->
                    ( { model | cookieConsent = state }, Cmd.none )

                CookieAccept ->
                    ( { model | cookieConsent = { accept = True } }, cookieAccept { accept = True } )

        MenuExpand expand ->
            ( { model | menuExpand = expand }, Cmd.none )

        OnPageChange page ->
            ( model, pageChange ("/" ++ PagePath.toString page.path) )

        _ ->
            ( model, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    Sub.batch [ Sub.map Cookie (cookieState CookieState) ]


view : MetadataContext -> StaticHttp.Request StaticRequest
view meta =
    case meta.frontmatter.metadata of
        MetadataBase base ->
            case base.feed of
                Just filterFeed ->
                    requestFeed filterFeed
                        |> StaticHttp.map
                            (\feed -> baseViewMeta meta base (Just feed))

                Nothing ->
                    StaticHttp.succeed (baseViewMeta meta base Nothing)

        MetadataPost post ->
            StaticHttp.succeed (postViewMeta meta post)

        MetadataUnknown ->
            StaticHttp.succeed { view = \_ _ -> { title = "", body = emptyNode }, head = [] }
