module Element.Header exposing (..)

import Context exposing (ContentContext, Msg)
import Html exposing (Html, a, div, header, nav, text)
import Html.Attributes exposing (class, href, rel, target)
import Pages.PagePath as PagePath exposing (PagePath)



{--TODO:- mobile version-}


headerView : ContentContext -> Html Msg
headerView { path, frontmatter } =
    header []
        [ div [ class "skipNavigation" ]
            [ a [ href (PagePath.toString path ++ "#mainContent") ] [ text "skip to content" ] ]
        , nav [ class "navigation" ]
            [ div [ class "navigation-content container" ]
                [ div [ class "navigation-content-menu" ]
                    [ div [ class "navigation-content-menu-brand" ]
                        [ a
                            [ href frontmatter.meta.navigation.brand.url ]
                            [ text frontmatter.meta.navigation.brand.text ]
                        ]
                    , div []
                        (frontmatter.meta.navigation.menu
                            |> List.map
                                (\item ->
                                    a
                                        [ href item.url
                                        , class
                                            (if item.url == ("/" ++ PagePath.toString path) then
                                                "navigation-content-menu-item active"

                                             else
                                                "navigation-content-menu-item"
                                            )
                                        ]
                                        [ text item.text ]
                                )
                        )
                    ]
                , div [ class "navigation-content-social" ]
                    (frontmatter.meta.navigation.social
                        |> List.map
                            (\item ->
                                a [ href item.url, target "_blank", rel "noopener noreferrer" ] [ text item.text ]
                            )
                    )
                ]
            ]
        ]
