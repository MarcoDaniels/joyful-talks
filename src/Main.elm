port module Main exposing (main)

import Content exposing (Content, ContentContext, contentDecoder, contentView)
import Head
import Html exposing (Html)
import Layout
import MainContext exposing (Model, Msg(..), PageContext)
import Manifest exposing (manifest)
import Metadata exposing (metadataHead)
import Pages exposing (internals)
import Pages.Platform
import Pages.StaticHttp as StaticHttp


type alias Renderer =
    List (Html Msg)


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
    ( { cookieConsent = False }, Cmd.none )


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
            ( { model | cookieConsent = True }, Cmd.none )

        NoOp _ ->
            ( model, Cmd.none )


subscriptions : Sub Msg
subscriptions =
    cookieState CookieState


view : ContentContext -> StaticHttp.Request { view : Model -> Renderer -> PageContext, head : List (Head.Tag Pages.PathKey) }
view dataContext =
    StaticHttp.succeed
        { view = \model _ -> Layout.view (contentView dataContext) dataContext model
        , head = metadataHead dataContext
        }
