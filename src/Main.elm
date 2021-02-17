port module Main exposing (main)

import Content exposing (contentDecoder)
import Context exposing (Content, ContentContext, Data(..), Model, Msg(..), PageData, Renderer)
import Head
import Html exposing (Html)
import Layout
import Manifest exposing (manifest)
import Metadata exposing (metadataHead)
import OptimizedDecoder as Decoder
import Page.Base exposing (baseView)
import Page.Post exposing (postView)
import Pages exposing (internals)
import Pages.Platform
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp


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


testing : StaticHttp.Request String
testing =
    StaticHttp.get
        (Secrets.succeed
            "https://api.github.com/repos/marcodaniels/joyful-talks"
        )
        (Decoder.field "full_name" Decoder.string)


view : ContentContext -> StaticHttp.Request { view : Model -> Renderer -> PageData, head : List (Head.Tag Pages.PathKey) }
view contentContext =
    case contentContext.frontmatter.data of
        BaseData baseData ->
            testing
                |> StaticHttp.map
                    (\_ ->
                        { view = \model _ -> Layout.view (baseView baseData) contentContext model
                        , head = metadataHead contentContext
                        }
                    )

        PostData postData ->
            StaticHttp.succeed
                { view = \model _ -> Layout.view (postView postData) contentContext model
                , head = metadataHead contentContext
                }

        _ ->
            StaticHttp.succeed
                { view = \model _ -> Layout.view { title = "", body = Html.div [] [] } contentContext model
                , head = metadataHead contentContext
                }
