port module Main exposing (main)

import Content exposing (contentDecoder, contentView)
import Context exposing (Content, ContentContext, Data(..), Model, Msg(..), PageData, Renderer, StaticRequest)
import Html exposing (Html)
import Manifest exposing (manifest)
import Page.Base exposing (baseView)
import Page.Post exposing (postView)
import Pages exposing (internals)
import Pages.Platform
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


view :
    ContentContext
    -> StaticHttp.Request StaticRequest
view contentContext =
    case contentContext.frontmatter.data of
        BaseData baseData ->
            contentView baseData.postsFeed contentContext (baseView baseData)

        PostData postData ->
            contentView Nothing contentContext (postView postData)

        UnknownData ->
            contentView Nothing contentContext { title = "", body = Html.div [] [] }
