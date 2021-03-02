module Element.Header exposing (..)

import Context exposing (ContentContext, Msg)
import Html exposing (Html, a, div, header, nav, text)
import Html.Attributes exposing (class, href)
import Pages.PagePath as PagePath exposing (PagePath)

{-- TODO:
- mobile drawer
- separate brand from menu
- include SM
-}

headerView : ContentContext -> Html Msg
headerView { path, frontmatter } =
    header []
        [ div [ class "skipNavigation" ] [ a [ href (PagePath.toString path ++ "#mainContent") ] [ text "skip to content" ] ]
        , nav [ class "navigation" ]
            [ div [ class "navigation-menu container" ]
                (frontmatter.meta.navigation.menu
                    |> List.map
                        (\item ->
                            a
                                [ href item.url
                                , class
                                    (if item.url == ("/" ++ PagePath.toString path) then
                                        "navigation-menu-item-active"

                                     else
                                        "navigation-menu-item"
                                    )
                                ]
                                [ text item.text ]
                        )
                )
            ]
        ]
