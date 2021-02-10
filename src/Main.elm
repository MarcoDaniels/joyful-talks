module Main exposing (main)

import Context exposing (DataContext, Msg, PageContext)
import Data.Decoder exposing (pageDecoder)
import Data.Render exposing (dataRender)
import Data.Types exposing (Base)
import Head
import Html exposing (Html)
import Layout
import Manifest exposing (manifest)
import Metadata exposing (metadataHead)
import Pages exposing (internals)
import Pages.PagePath as Pages exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp


type alias Model =
    {}


type alias Renderer =
    List (Html Msg)


main : Pages.Platform.Program Model Msg Base Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents =
            [ { extension = "md"
              , metadata = pageDecoder
              , body = \_ -> Ok (Html.div [] [] |> List.singleton)
              }
            ]
        , manifest = manifest
        , canonicalSiteUrl = "https://joyfultalks.com"
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.toProgram


init : ( Model, Cmd msg )
init =
    ( {}, Cmd.none )


update : msg -> Model -> ( Model, Cmd msg )
update _ model =
    ( model, Cmd.none )


subscriptions : Base -> PagePath Pages.PathKey -> Model -> Sub msg
subscriptions _ _ _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Base )
    -> DataContext
    ->
        StaticHttp.Request
            { view : Model -> Renderer -> PageContext
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata dataContext =
    StaticHttp.succeed
        { view =
            \_ _ ->
                Layout.view (dataRender siteMetadata dataContext) dataContext
        , head = metadataHead dataContext
        }
