module Main exposing (main)

import Head
import Html exposing (Html)
import Html.Attributes exposing (src)
import Layout
import Manifest exposing (manifest)
import Page exposing (PageContent(..))
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


main : Pages.Platform.Program Model Msg Page.Page Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents =
            [ { extension = "md"
              , metadata = Page.pageDecoder
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
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        () ->
            ( model, Cmd.none )


subscriptions : Page.Page -> PagePath Pages.PathKey -> Model -> Sub msg
subscriptions _ _ _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Page.Page )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Page.Page
        }
    ->
        StaticHttp.Request
            { view : Model -> Renderer -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.succeed
        { view =
            \model _ ->
                Layout.view (pageView model siteMetadata page) page
        , head =
            [ Head.rssLink "/feed.xml"
            , Head.sitemapLink "/sitemap.xml"
            ]
        }


pageView :
    Model
    -> List ( PagePath Pages.PathKey, Page.Page )
    -> { path : PagePath Pages.PathKey, frontmatter : Page.Page }
    -> { title : String, body : Html Msg }
pageView _ _ page =
    { title = page.frontmatter.title
    , body =
        Html.div []
            (page.frontmatter.content
                |> List.map
                    (\content ->
                        case content of
                            PageText text ->
                                Html.text text.value

                            PageImage image ->
                                Html.img [ src image.value.path ] []
                    )
            )
    }
