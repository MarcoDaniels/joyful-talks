module Main exposing (main)

import Content exposing (Content, ContentContext, contentDecoder, contentView)
import MainContext exposing (Model, Msg(..), PageContext)
import Head
import Html exposing (Html)
import Layout
import Manifest exposing (manifest)
import Metadata exposing (metadataHead)
import Pages exposing (internals)
import Pages.PagePath as Pages exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp


type alias Renderer =
    List (Html Msg)


main : Pages.Platform.Program Model Msg Content Renderer Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
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


init : ( Model, Cmd msg )
init =
    ( { count = 0 }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        Reset ->
            ( { model | count = 0 }, Cmd.none )

        NoOp _ ->
            ( model, Cmd.none )


subscriptions : Content -> PagePath Pages.PathKey -> Model -> Sub msg
subscriptions _ _ _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Content )
    -> ContentContext
    ->
        StaticHttp.Request
            { view : Model -> Renderer -> PageContext
            , head : List (Head.Tag Pages.PathKey)
            }
view _ dataContext =
    StaticHttp.succeed
        { view = \model _ -> Layout.view (contentView dataContext) dataContext model
        , head = metadataHead dataContext
        }
