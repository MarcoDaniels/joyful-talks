module Element.Counter exposing (..)

import MainContext exposing (Msg(..))
import Html exposing (Html)
import Html.Attributes
import Html.Events


counterView : Int -> Html Msg
counterView count =
    Html.div [ Html.Attributes.class "center" ]
        [ Html.div []
            [ Html.button [ Html.Events.onClick Increment ] [ Html.text "+" ]
            , Html.button [ Html.Events.onClick Decrement ] [ Html.text "-" ]
            ]
        , Html.div [] [ Html.text (String.fromInt count) ]
        , Html.button [ Html.Events.onClick Reset ] [ Html.text "Reset" ]
        ]
