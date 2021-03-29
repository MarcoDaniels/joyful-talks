module Element.Share exposing (shareView)

import Body.Type exposing (PostPage)
import Context exposing (Element)
import Element.Icon exposing (Icons(..), iconView)
import Html exposing (a, div, span, text)
import Html.Attributes exposing (class, href, rel, target, title)


shareView : PostPage -> Element
shareView post =
    div [ class "post-share font-m" ]
        [ span [] [ text "Be awesome! Let others know about it:" ]
        , div []
            [ a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href
                    ("https://www.facebook.com/sharer/sharer.php?u="
                        ++ post.url
                        ++ "&p[title]="
                        ++ post.title
                    )
                , title ("share " ++ post.title ++ " on facebook")
                ]
                [ iconView Facebook { size = "16", color = "#000" }
                ]
            , a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href
                    ("http://twitter.com/share?text="
                        ++ post.title
                        ++ "&url="
                        ++ post.url
                    )
                , title ("share " ++ post.title ++ " on twitter")
                ]
                [ iconView Twitter { size = "16", color = "#000" }
                ]
            , a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href
                    ("http://pinterest.com/pin/create/button/?url="
                        ++ post.url
                        ++ "&media="
                        ++ (case post.asset of
                                Just asset ->
                                    asset.path

                                Nothing ->
                                    ""
                           )
                        ++ "&description="
                        ++ post.description
                    )
                , title ("share " ++ post.title ++ " on pinterest")
                ]
                [ iconView Pinterest { size = "16", color = "#000" }
                ]
            , a
                [ target "_blank"
                , rel "noopener noreferrer"
                , href
                    ("http://www.linkedin.com/shareArticle?mini=true&url="
                        ++ post.url
                        ++ "&title="
                        ++ post.title
                        ++ "&summary="
                        ++ post.description
                    )
                , title ("share " ++ post.title ++ " on linkedin")
                ]
                [ iconView LinkedIn { size = "16", color = "#000" }
                ]
            ]
        ]
