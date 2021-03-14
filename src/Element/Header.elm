module Element.Header exposing (headerView)

import Context exposing (Element, MetadataContext, Model, Msg(..))
import Element.Empty exposing (emptyNode)
import Element.Icon exposing (Icons(..), iconView)
import Html exposing (a, button, div, header, li, nav, text, ul)
import Html.Attributes exposing (class, href, rel, target)
import Html.Events exposing (onClick)
import Metadata.Type exposing (Navigation)
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Shared.Ternary exposing (ternary)


headerView : PagePath Pages.PathKey -> Navigation -> Bool -> Element
headerView path navigation expand =
    header []
        [ div [ class "header" ]
            [ a [ class "header-skip", href (PagePath.toString path ++ "#content") ] [ text "skip to content" ]
            , div [ class "header-nav container" ]
                [ nav [ class "header-nav-main" ]
                    [ ul []
                        [ li [ class "header-nav-main-brand" ]
                            [ a
                                [ class "link-primary font-l font-dancing"
                                , href navigation.brand.url
                                , onClick (MenuExpand False)
                                ]
                                [ text navigation.brand.text ]
                            , button [ class "header-nav-main-button", onClick (MenuExpand (not expand)) ]
                                [ ternary expand
                                    (iconView Close { size = "15", color = "#3f3f3f" })
                                    (iconView Burger { size = "15", color = "#3f3f3f" })
                                ]
                            ]
                        ]
                    , ul [ class ("header-nav-main-items" ++ ternary expand " show" "") ]
                        (navigation.menu
                            |> List.map
                                (\item ->
                                    li
                                        [ class "header-nav-item" ]
                                        [ a
                                            [ class ("link-primary-effect font-m" ++ ternary (item.url == ("/" ++ PagePath.toString path)) "active" "")
                                            , href item.url
                                            , onClick (MenuExpand False)
                                            ]
                                            [ text item.text ]
                                        ]
                                )
                        )
                    ]
                , nav [ class ("header-nav-extra" ++ ternary expand " show" "") ]
                    [ ul []
                        (navigation.social
                            |> List.map
                                (\item ->
                                    li [ class "header-nav-item" ]
                                        [ a
                                            [ class "link-primary-effect", href item.url, target "_blank", rel "noopener noreferrer" ]
                                            [ case String.toLower item.text of
                                                "facebook" ->
                                                    iconView Facebook { size = "12", color = "#000" }

                                                "instagram" ->
                                                    iconView Instagram { size = "12", color = "#000" }

                                                "pinterest" ->
                                                    iconView Pinterest { size = "12", color = "#000" }

                                                "rss" ->
                                                    iconView Rss { size = "12", color = "#000" }

                                                _ ->
                                                    emptyNode
                                            ]
                                        ]
                                )
                        )
                    ]
                ]
            ]
        , div [ class ("overlay" ++ ternary expand " show" ""), onClick (MenuExpand False) ] []
        ]
