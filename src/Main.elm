module Main exposing (main)

import Head
import Html exposing (Html)
import Layout
import Manifest exposing (manifest)
import MarkdownParser exposing (document)
import Metadata exposing (Metadata)
import Pages exposing (internals)
import Pages.PagePath as Pages exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp


type alias Model =
    {}


type alias Msg =
    ()


type alias Renderer =
    List (Html Msg)


main : Pages.Platform.Program Model Msg Metadata Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ document ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.toProgram


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Metadata -> PagePath Pages.PathKey -> Model -> Sub msg
subscriptions _ _ _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Renderer -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
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


pageView :
    Model
    -> List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> Renderer
    -> { title : String, body : Renderer }
pageView _ _ page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body = viewForPage
            }
