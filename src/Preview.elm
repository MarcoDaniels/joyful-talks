port module Preview exposing (..)

import Browser
import Html exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port updateTitle : (String -> msg) -> Sub msg


type alias Model =
    { name : String }


type Msg
    = UpdateTitle String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = "no title" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTitle newTitle ->
            ( { model | name = newTitle }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    updateTitle UpdateTitle


view : Model -> Html Msg
view model =
    div [] [ text model.name ]
