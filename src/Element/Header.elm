module Element.Header exposing (..)

import Context exposing (ContentContext, Model, Msg(..))
import Html exposing (Html, a, button, div, header, li, nav, text, ul)
import Html.Attributes exposing (class, href, rel, tabindex, target)
import Html.Events exposing (onClick)
import Pages.PagePath as PagePath exposing (PagePath)
import Shared.Ternary exposing (ternary)


headerView : ContentContext -> Bool -> Html Msg
headerView { path, frontmatter } expand =
    header [ class "header" ]
        [ a [ class "header-skip", href (PagePath.toString path ++ "#content") ] [ text "skip to content" ]
        , div [ class "header-nav container" ]
            [ nav [ class "header-nav-main" ]
                [ ul []
                    [ li [ class "header-nav-main-brand" ]
                        [ a
                            [ href frontmatter.meta.navigation.brand.url, onClick (MenuExpand False) ]
                            [ text frontmatter.meta.navigation.brand.text ]
                        , button [ class "header-nav-main-button", onClick (MenuExpand (not expand)) ]
                            [ text (ternary expand "X" "=") ]
                        ]
                    ]
                , ul [ class ("header-nav-main-items" ++ ternary expand " show" "") ]
                    (frontmatter.meta.navigation.menu
                        |> List.map
                            (\item ->
                                li
                                    [ class
                                        (ternary
                                            (item.url == ("/" ++ PagePath.toString path))
                                            "header-nav-item active"
                                            "header-nav-item"
                                        ), tabindex -1
                                    ]
                                    [ a [ href item.url, onClick (MenuExpand False) ] [ text item.text ] ]
                            )
                    )
                ]
            , nav [ class ("header-nav-extra" ++ ternary expand " show" "") ]
                [ ul []
                    (frontmatter.meta.navigation.social
                        |> List.map
                            (\item ->
                                li [ class "header-nav-item" ]
                                    [ a
                                        [ href item.url, target "_blank", rel "noopener noreferrer" ]
                                        [ text item.text ]
                                    ]
                            )
                    )
                ]
            ]
        ]
