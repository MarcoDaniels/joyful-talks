module Main exposing (main)

import Color
import Head
import Html exposing (Html)
import Layout
import Markdown.Parser
import Markdown.Renderer
import Metadata exposing (Metadata)
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform
import Pages.StaticHttp as StaticHttp


main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = Pages.internals
        }
        |> Pages.Platform.toProgram


manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "joyful talks about people and all the rest"
    , iarcRatingId = Nothing
    , name = "joyful talks"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "joyful talks"
    , sourceIcon = images.iconPng
    , icons = []
    }


markdownDocument =
    { extension = "md"
    , metadata = Metadata.decoder
    , body =
        \markdownBody ->
            Markdown.Parser.parse markdownBody
                |> Result.withDefault []
                |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
                |> Result.withDefault [ Html.text "" ]
                |> Html.div []
                |> List.singleton
                |> Ok
    }


init =
    ( {}, Cmd.none )


update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions _ _ _ =
    Sub.none


view siteMetadata page =
    StaticHttp.succeed
        { view =
            \model viewForPage ->
                Layout.view (pageView model siteMetadata page viewForPage) page
        , head =
            [ Head.rssLink "/feed.xml"
            , Head.sitemapLink "/sitemap.xml"
            ]
        }


pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body = viewForPage
            }
