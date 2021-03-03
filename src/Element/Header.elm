module Element.Header exposing (..)

import Context exposing (ContentContext, Msg)
import Html exposing (Html, a, button, div, header, li, nav, text, ul)
import Html.Attributes exposing (class, href, rel, target)
import Pages.PagePath as PagePath exposing (PagePath)


headerView : ContentContext -> Html Msg
headerView { path, frontmatter } =
    header [ class "header" ]
        [ a [ class "header-skip", href (PagePath.toString path ++ "#content") ] [ text "skip to content" ]
        , div [ class "header-nav container" ]
            [ nav [ class "header-nav-main" ]
                [ ul []
                    [ li [ class "header-nav-main-brand" ]
                        [ a
                            [ href frontmatter.meta.navigation.brand.url ]
                            [ text frontmatter.meta.navigation.brand.text ]
                        , button [ class "header-nav-main-button" ] [ text "=" ]
                        ]
                    ]
                , ul [ class "header-nav-main-items" ]
                    (frontmatter.meta.navigation.menu
                        |> List.map
                            (\item ->
                                li
                                    [ class
                                        (if item.url == ("/" ++ PagePath.toString path) then
                                            "header-nav-item active"

                                         else
                                            "header-nav-item"
                                        )
                                    ]
                                    [ a [ href item.url ] [ text item.text ] ]
                            )
                    )
                ]
            , nav [ class "header-nav-extra" ]
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
